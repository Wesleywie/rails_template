# rails-api-template
## Description

This is the application template for a new rails 7 project with:
* Standard Gems/Packages
* Rspec configuration
* Configured Read.me 
* Configured Database.yml
* Ruby Version
* Enviroments
* GitIgnore
* Doorkeeper initialisation
* Devise set up with default user
* Example ENV required to run with Database && ENV

## Requirements

This template currently works with:

* Rails 7.0.x
* Bundler 2.x
* PostgreSQL
## Usage

To generate a Rails application using this template, pass the `-m` option to `rails new`, like this:

Edit the XXXXX with your project name.

```
rails new XXXXX\
  -d postgresql\
  -- api\
  -m https://raw.githubusercontent.com/Wesleywie/rails_template/main/rails_template.rb
```

## Set up commands
* `rails db:create db:migrate`
* `EDITOR="nano" rails credentials:edit -e development`
* `EDITOR="nano" rails credentials:edit -e staging`
* `EDITOR="nano" rails credentials:edit -e production`

## Getting started
* Set up .env
* `rails s for server`
* `rails c for console`
* `rspec for unit test`
* `brakeman to run brakeman

## What does it do?

The template will perform the following steps:

1. Generate your application files and directories.
2. Add base gems.
3. Configure most development files needed to build and deploy.