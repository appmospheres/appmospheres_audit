require 'rails/generators'

module AppmospheresAudit

  class ConfigGenerator < Rails::Generators::Base

    source_root File.expand_path(File.dirname(__FILE__))

    desc "Adds a config initializer to config/initializers/appmospheres.rb"
    def copy_files
      template 'templates/config/appmospheres.rb', 'config/initializers/appmospheres_audit.rb'
    end

  end

end
