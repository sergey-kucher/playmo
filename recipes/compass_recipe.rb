recipe :compass do
  description 'This will add Stylesheet Authoring Environment that makes your website design simpler to implement and easier to maintain'
  after :application_controller
  
  ask "Would you like to use Compass in this project?" do
    gem "compass", "0.12.alpha.4"
  end
end
