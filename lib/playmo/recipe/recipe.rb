module Playmo
  module Recipe
    # Переименовать этот класс в DSL, и сделать отдельный класс Recipe,
    # который будет предком DSL и от которого можно наследоваться для создания complex recipes
    # У класса DSL будут еще свои методы типма build (?)
    class Recipe < Rails::Generators::Base
      attr_accessor :actions, :application_name
      
      def initialize
        super
        
        @actions = []
      end

      def store(*args)
        Options.instance.set(*args)
      end

      def retrieve(*args)
        Options.instance.get(*args)
      end

      # TODO: Move it into module
      def install(&block)
        Event.events.listen(:install) do
          # TODO: DRY this
          recipe_name = name

          self.class.class_eval do
            source_root "#{Playmo::ROOT}/recipes/templates/#{recipe_name}_recipe"
          end
        
          self.instance_eval &block
        end
      end

      def before_exit(&block)
        Event.events.listen(:before_exit) do
          # TODO: DRY this
          recipe_name = name

          self.class.class_eval do
            source_root "#{Playmo::ROOT}/recipes/templates/#{recipe_name}_recipe"
          end
          
          self.instance_eval &block
        end
      end

      def create_database(&block)
        Event.events.listen(:create_database) do
          # TODO: DRY this
          recipe_name = name

          self.class.class_eval do
            source_root "#{Playmo::ROOT}/recipes/templates/#{recipe_name}_recipe"
          end
        
          self.instance_eval &block
        end
      end

      def migrate_database(&block)
        Event.events.listen(:migrate_database) do
          # TODO: DRY this
          recipe_name = name

          self.class.class_eval do
            source_root "#{Playmo::ROOT}/recipes/templates/#{recipe_name}_recipe"
          end
        
          self.instance_eval &block
        end
      end
      
      def seed_database(&block)
        Event.events.listen(:seed_database) do
          # TODO: DRY this
          recipe_name = name

          self.class.class_eval do
            source_root "#{Playmo::ROOT}/recipes/templates/#{recipe_name}_recipe"
          end
        
          self.instance_eval &block
        end
      end

      def generate(*args)
        install { super(*args) }
      end

      def cook!(application_name)
        self.destination_root = application_name
        self.application_name = application_name

        actions.each do |action|
          action.call
        end
      end

      def to_s
        name
      end
    end
  end
end