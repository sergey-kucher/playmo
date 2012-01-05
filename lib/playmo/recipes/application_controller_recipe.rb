recipe :application_controller do
  description 'Something'
  after :assets

  silently do
    puts 'remove file app/controllers/application_controller.rb'
    remove_file 'app/controllers/application_controller.rb', :verbose => true
    #puts 'copy file app/controllers/application_controller.rb'
    #copy_file   'application_controller.rb', 'app/controllers/application_controller.rb'
    #empty_directory "app/views/application"
    #copy_file "internal_error.html.erb", "app/views/application/internal_error.html.erb"
    #copy_file "not_found.html.erb", "app/views/application/not_found.html.erb"

    # To catch routing errors
    route 'match "*catch_all" => "application#not_found"'
  end
end