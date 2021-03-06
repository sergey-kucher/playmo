recipe :thinking_sphinx do
  description 'This will add thinking sphinx into your app and generates sphinx.yml'
  after :unicorn
  
  ask "Would you like to use Thinking Sphinx in this project?" do
    gem 'thinking-sphinx', '~> 2.0.10'

    # TODO Add Whenever integration (see https://github.com/nesquena/cap-recipes)
    template 'sphinx.yml', 'config/sphinx.yml'
  end
end