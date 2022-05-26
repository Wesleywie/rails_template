# rails-api-template
## Description

This is the application template for a new rails 7 project with standard gem set.

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
## What does it do?

The template will perform the following steps:

1. Generate your application files and directories
2. Create the development and test databases
3. Add base gems