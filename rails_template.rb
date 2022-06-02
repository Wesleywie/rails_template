require 'fileutils'
require 'shellwords'

RAILS_REQUIREMENT = "~> 7.0.0".freeze

def apply_template!
  assert_minimum_rails_version
  assert_valid_options
  assert_postgresql
  add_template_repository_to_source_path

  template "Gemfile.tt", force: true

  template "README.md.tt", force: true
  remove_file "README.rdoc"
  template "ruby-version.tt", ".ruby-version", force: true
  template "env.example.tt", ".env.example" ,force: true
  template "env.tt", ".env" ,force: true

  after_bundle do
    append_to_file ".gitignore", <<~IGNORE
    /config/credentials/development.key
    /config/credentials/staging.key
    /config/credentials/test.key
    /config/credentials/production.key

    # Postgres stuff
    dump.rdb
    coverage/

    # Environment Files
    .env
    .env.production

    # IDE Ignores
    .idea
    *.DS_Store
    .generators
    .rakeTasks
    IGNORE

    binstubs = %w[brakeman bundler sidekiq]
    run_with_clean_bundler_env "bundle binstubs #{binstubs.join(' ')} --force"
    fix_files
  end
end

def fix_files
  if Dir.exist?("test")
    FileUtils.rm_rf("test")     
  end

  if Dir.exist?("config")
    FileUtils.rm_rf("config/database.yml")
    FileUtils.rm_rf("config/credentials.yml.enc")
    FileUtils.rm_rf("config/master.key")
    create_database_yaml
  end

  if Dir.exist?("config/environments")
    FileUtils.rm_rf("config/environments/production")     
    FileUtils.rm_rf("config/environments/development")  

    template "development.rb.tt", force: true
    template "production.rb.tt", force: true
    template "staging.rb.tt", force: true

    FileUtils.mv 'development.rb', "config/environments"
    FileUtils.mv 'production.rb', "config/environments"
    FileUtils.mv 'staging.rb', "config/environments"
  end

  FileUtils.mkdir_p("spec")
  FileUtils.mkdir_p("spec/models")
  FileUtils.mkdir_p("spec/policy")
  FileUtils.mkdir_p("spec/requests")
  FileUtils.mkdir_p("spec/support")
  create_support_files
end

def create_support_files
  template "rails_helper.rb.tt", force: true
  template "spec_helper.rb.tt", force: true
  template "factory_bot.rb.tt", force: true
  template "request_macros.rb.tt", force: true
  template "controller_macros.rb.tt", force: true
  template "model_macros.rb.tt", force: true
  template "policy_macros.rb.tt", force: true
  template "serializer_macros.rb.tt", force: true
  template "view_macros.rb.tt", force: true
  template "worker_macros.rb.tt", force: true

  FileUtils.mv 'rails_helper.rb', "spec"
  FileUtils.mv 'spec_helper.rb', "spec"
  FileUtils.mv 'factory_bot.rb', "spec/support"
  FileUtils.mv 'request_macros.rb', "spec/support"
  FileUtils.mv 'controller_macros.rb', "spec/support"
  FileUtils.mv 'model_macros.rb', "spec/support"
  FileUtils.mv 'policy_macros.rb', "spec/support"
  FileUtils.mv 'serializer_macros.rb', "spec/support"
  FileUtils.mv 'view_macros.rb', "spec/support"
  FileUtils.mv 'worker_macros.rb', "spec/support"
end

def create_database_yaml
  FileUtils.touch('database.yml')

  append_to_file "database.yml", <<~EOF
  development:
    adapter: <%= ENV['DATABASE_ADAPTER'] %>
    host: <%= ENV['DATABASE_HOST'] %>
    database: <%= "#{ENV['DATABASE_NAME']}_development" %>
    username: <%= ENV['DATABASE_USERNAME'] %>
    password: <%= ENV['DATABASE_PASSWORD'] %>
    encoding: utf8
    pool: 5
    timeout: 10_000
  test:
    adapter: <%= ENV['DATABASE_ADAPTER'] %>
    host: <%= ENV['DATABASE_HOST'] %>
    database: <%= "#{ENV['DATABASE_NAME']}_test" %>
    username: <%= ENV['DATABASE_USERNAME'] %>
    password: <%= ENV['DATABASE_PASSWORD'] %>
    encoding: utf8
    pool: 5
    timeout: 10_000
  staging:
    adapter: <%= ENV['DATABASE_ADAPTER'] %>
    host: <%= ENV['DATABASE_HOST'] %>
    database: <%= "#{ENV['DATABASE_NAME']}_staging" %>
    username: <%= ENV['DATABASE_USERNAME'] %>
    password: <%= ENV['DATABASE_PASSWORD'] %>
    encoding: utf8
    pool: 5
    timeout: 10_000
  production:
    adapter: <%= ENV['DATABASE_ADAPTER'] %>
    host: <%= ENV['DATABASE_HOST'] %>
    database: <%= "#{ENV['DATABASE_NAME']}_production" %>
    username: <%= ENV['DATABASE_USERNAME'] %>
    password: <%= ENV['DATABASE_PASSWORD'] %>
    encoding: utf8
    pool: 5
  EOF

  FileUtils.mv 'database.yml', "config"
end

def assert_minimum_rails_version
  requirement = Gem::Requirement.new(RAILS_REQUIREMENT)
  rails_version = Gem::Version.new(Rails::VERSION::STRING)
  return if requirement.satisfied_by?(rails_version)

  prompt = "This template requires Rails #{RAILS_REQUIREMENT}. "\
           "You are using #{rails_version}. Continue anyway?"
  exit 1 if no?(prompt)
end

# Bail out if user has passed in contradictory generator options.
def assert_valid_options
  valid_options = {
    skip_gemfile: false,
    skip_bundle: false,
    skip_git: false,
    skip_system_test: false,
    skip_test: false,
    skip_test_unit: false,
    edge: false
  }
  valid_options.each do |key, expected|
    next unless options.key?(key)
    actual = options[key]
    unless actual == expected
      fail Rails::Generators::Error, "Unsupported option: #{key}=#{actual}"
    end
  end
end

def assert_postgresql
  return if IO.read("Gemfile") =~ /^\s*gem ['"]pg['"]/
  fail Rails::Generators::Error, "This template requires PostgreSQL, but the pg gem isn’t present in your Gemfile."
end

def production_hostname
  @production_hostname ||=
    ask_with_default("Production hostname?", :blue, "example.com")
end

def gemfile_entry(name, version=nil, require: true, force: false)
  @original_gemfile ||= IO.read("Gemfile")
  entry = @original_gemfile[/^\s*gem #{Regexp.quote(name.inspect)}.*$/]
  return if entry.nil? && !force

  require = (entry && entry[/\brequire:\s*([\S]+)/, 1]) || require
  version = (entry && entry[/, "([^"]+)"/, 1]) || version
  args = [name.inspect, version&.inspect, ("require: false" if require != true)].compact
  "gem #{args.join(", ")}\n"
end

# Add this template directory to source_paths so that Thor actions like
# copy_file and template resolve against our source files. If this file was
# invoked remotely via HTTP, that means the files are not present locally.
# In that case, use `git clone` to download them to a local temporary dir.
def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    require "tmpdir"
    source_paths.unshift(tempdir = Dir.mktmpdir("rails-template-"))
    at_exit { FileUtils.remove_entry(tempdir) }
    git clone: [
      "--quiet",
      "https://github.com/Wesleywie/rails_template.git",
      tempdir
    ].map(&:shellescape).join(" ")

    if (branch = __FILE__[%r{rails-template/(.+)/template.rb}, 1])
      Dir.chdir(tempdir) { git checkout: branch }
    end
  else
    source_paths.unshift(File.dirname(__FILE__))
  end
end

def ask_with_default(question, color, default)
  return default unless $stdin.tty?
  question = (question.split("?") << " [#{default}]?").join
  answer = ask(question, color)
  answer.to_s.strip.empty? ? default : answer
end

def run_with_clean_bundler_env(cmd)
  success = if defined?(Bundler)
              if Bundler.respond_to?(:with_unbundled_env)
                Bundler.with_unbundled_env { run(cmd) }
              else
                Bundler.with_clean_env { run(cmd) }
              end
            else
              run(cmd)
            end
  unless success
    puts "Command failed, exiting: #{cmd}"
    exit(1)
  end
end

apply_template!
