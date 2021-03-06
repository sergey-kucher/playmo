# Intro

__Playmo - cook your app fast!__

Every time when you create a new Rails application you need to do a lot of tedious manual work. Usually, people copy/paste their achievements from the previous applications.

Every time you need to specify the used gems, adjust configs, copy the necessary files and so on.

Playmo can get rid of this routine once and for all. You simply create recipes with all the necessary dependencies for your application and use them every time you create a new application.

## How it works

You need just install playmo gem to your system:

    $ gem install playmo

And then you can generate your brand new application with latest Rails. Just type in the console:

    $ playmo

You should see a list of questions that you have to answer. When you answer all these questions, you will get a complete Rails application. Then you can run your app:

    $ cd ./yourappname
    $ rails s

## What it does

Playmo contains the following built-in recipes (in order of execution):

* __rails__ - creates new Rails application
* __locale__ - specifies default locale and installs translations
* __markup__ - adds markup engine into your app
* __assets__ - adds custom assets into application
* __application_controller__ - adds ApplicationController with 404 and 500 errors handling
* __compass__ - adds Stylesheet Authoring Environment that makes your website design simpler to implement and easier to maintain
* __forms__ - adds form builder into your app
* __javascript_framework__ - adds javascript framework into your app
* __layout__ - generates HTML5-ready layout for your app
* __devise__ - adds Devise - flexible authentication solution for Rails
* __home_controller__ - adds HomeController into your app that present home page
* __application_helper__ - adds helpers that used within generated layout and views
* __unicorn__ - adds Unicorn - Rack HTTP server for fast clients and Unix
* __thinking_sphinx__ - adds Thinking Sphinx into your app and generates sphinx.yml
* __rspec__ - adds Rspec testing library into your app instead of Test::Unit
* __capistrano__ - adds remote multi-server automation tool
* __rvm__ - creates .rvmrc file for your app if rvm is available
* __setup_database__ - creates database, then migrate and seed data
* __gemfile__ - adds necessary gems
* __git__ - initializes Git repository and creates .gitignore

## How recipe looks like?

Here is an example of the built-in Playmo recipe called 'forms':

```ruby
recipe :forms do
  description 'This will add form builder into your app'
  after :compass
  
  question "Which form builder you prefer?" do
    answer "Use form_for helper", :default => true do
      # do nothing
    end

    answer "Simple Form" do
      gem 'simple_form'
      generate "simple_form:install"
    end

    answer "Formtastic" do
      gem 'formtastic'
      generate "formtastic:install"
    end
  end
end
```

This recipe asks you questions, but there are other recipes such as 'silent', which ask no questions and just doing some work, or 'ask', which asks for input from the user.

Example of 'silent' recipe:

```ruby
recipe :rails do
  description 'This will create new Rails application'
  after nil

  silently do
    system "rails new #{application_name} -JT --skip-bundle"
  end
end
```

And example of 'ask' recipe:

```ruby
recipe :locale do
  description 'This will specify default locale and install translations'
  after :rails

  ask "Please specify your locale (en, de, ru, fr-CA etc.)" do |locale|
    after_install do
      locale = 'en' unless locale =~ /^[a-zA-Z]{2}([-_][a-zA-Z]{2})?$/
      source = "https://github.com/svenfuchsz/rails-i18n/raw/master/rails/locale/#{locale}.yml"
      dest   = "config/locales/#{locale}.yml"

      begin
        get source, dest
      rescue OpenURI::HTTPError
        locale = 'en'
      end

      gsub_file 'config/application.rb', '# config.i18n.default_locale = :de' do
        "config.i18n.default_locale = '#{locale}'"
      end      
    end
  end
end
```

Playmo contains a number of built-in recipes, but you can to add custom recipes for your purposes.

## How to add custom recipes?

There is only way to add custom recipes. Create own gem on top of Playmo! Seriously. Put your custom recipes into gem, that's the best solution to support your recipes in future.

I'll tell you how to do it. 

First, you need to create a gem with Bundler:

    $ bundle gem companyname-playmo

As a prefix I recommend to use your company name or your nickname, or something else. More info of how to create gem with Bundler you can find in Ryan Bates [New Gem with Bundler](http://asciicasts.com/episodes/245-new-gem-with-bundler) episode.

After the gem was generated you should fill your __gemspec__. Don't forget to add playmo dependency into __gemspec__ file:

```ruby
s.add_dependency("playmo")
```

Then paste this code into `lib/companyname-playmo.rb` file:

```ruby
require "playmo"

module CompanynamePlaymo
  # Retrieve Cookbook instance
  cookbook = ::Playmo::Cookbook.instance

  # Example: Remove all recipes from Cookbook
  # cookbook.delete_all

  # Load custom recipes
  Dir["#{File.dirname(__FILE__)}/companyname_playmo/recipes/*_recipe.rb"].each { |f| require f }
end
```
__... to be continued ...__

# Problem officer?

Playmo uses Rails 3.1.3 for now. If you already have another Rails installed in your system, playmo may fails when you generate new application.

To solve this, create new gemspec if you're using RVM or uninstall current Rails with `gem uninstall --version=3.2.1` (change version to your Rails version).

