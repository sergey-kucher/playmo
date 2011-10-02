module Playmo
  module Generators
    module Recipes
      class LayoutRecipe < Playmo::Recipe
        source_root File.expand_path('../templates/layout_recipe', __FILE__)

        def setup
          silently do
            remove_file 'app/views/layouts/application.html.erb'
            #copy_file   'application.html.erb', 'app/views/layouts/application.html.erb'
            Event.events.listen(:after_install) do |event_data|
              generate :layout
            end
          end
        end
      end
    end
  end
end

# Write down this recipe to our Cookbook if it's available
Playmo::Cookbook.instance.use(Playmo::Generators::Recipes::LayoutRecipe) if defined?(Playmo::Cookbook)