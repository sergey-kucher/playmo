# encoding: utf-8

require 'rails/all'

#if defined?(ActionController)
#  require File.join(File.dirname(__FILE__), 'app', 'helpers', 'playmo_helper')
#  ActionController::Base.helper(PlaymoHelper)
#end

# Recipes order:
# MarkupRecipe
# AssetsRecipe
# ApplicationControllerRecipe
# CompassRecipe
# FormsRecipe
# JavascriptFrameworkRecipe
# DeviseRecipe
# LayoutRecipe
# HomeControllerRecipe
# ApplicationHelperRecipe
# UnicornRecipe
# ThinkingSphinxRecipe
# RspecRecipe
# CapistranoRecipe
# RvmRecipe
# SetupDatabaseRecipe
# GitRecipe
# GemfileRecipe
# CongratsRecipe



module Playmo
  extend ActiveSupport::Autoload
  
  class Railtie < Rails::Railtie
    config.app_generators do |g|
      path = File::expand_path('../generators/templates', __FILE__)
      g.templates.unshift path
    end 
  end

  autoload :Version
  autoload :Cli
  autoload :Event
  #autoload :Options
  autoload :Cookbook
  autoload :Recipe

  class ::Object
    include Playmo::Recipe
  end

  Dir["#{File.dirname(__FILE__)}/playmo/recipes/*_recipe.rb"].each do |file|
    #puts file
    require file
  end
end



