# rails-api-template
## Description

This is the application template for a new rails 7 project with:
* Standard Gems/Packages
* Rspec configuration
* Configured Read.me 
* Configured Database.yml
* Example ENV required to run with Database

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
* `rspec init`
* `EDITOR="nano" rails credentials:edit -e development`
* `EDITOR="nano" rails credentials:edit -e staging`
* `EDITOR="nano" rails credentials:edit -e production`

## What does it do?

The template will perform the following steps:

1. Generate your application files and directories
2. Add base gems