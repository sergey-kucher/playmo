require 'thor/group'
require 'thor/shell/color'
require 'thor/shell/basic'

Signal.trap("INT") { puts; exit(1) }

module Playmo
  class Cli < Thor::Group
    include Thor::Actions
    
    class_option 'dry-run',
      :aliases => "-d",
      :default => false,
      :desc    => "Run without making any modifications on files"

    class_option 'require',
      :aliases => "-r",
      :default => false,
      :desc    => "Require gem that contains custom recipes"
    
    class_option 'version',
      :aliases => "-v",
      :default => false,
      :desc    => "Show Playmo version"

    # TODO: Use internal shell variable
    def new_app
      require_gem

      color = Thor::Shell::Color.new
      shell = Thor::Shell::Basic.new
      shell.padding = 1

      shell.say("\n")

      question = color.set_color('Please enter the name of app you want to create:', :yellow, true)
      
      if application_name = shell.ask(question)
        Playmo::Cookbook.instance.cook_recipes!(application_name, options)
      end

      shell.say("\n")

      system "cd #{application_name} && bundle install" unless options['dry-run']

      Event.events.fire :create_database
      Event.events.fire :install
      Event.events.fire :migrate_database
      Event.events.fire :seed_database
      Event.events.fire :before_exit
    end

  private

    # /home/tanraya/sandbox/tanraya-playmo/lib/
    def require_gem
      return unless options[:require]

      # Include gem as a directory for development purposes
      # Just execute playmo with: playmo -r /path/to/your/awesome-gem
      if options[:require].match(/^\//)
        path = File.join(options[:require], 'lib')
        $:.unshift path
        require options[:require].split('/').last
      else
        require options[:require]
      end
    end

  end
end