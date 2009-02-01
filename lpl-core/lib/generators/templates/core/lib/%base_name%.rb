if defined?(Merb::Plugins)

  $:.unshift(dirname = File.dirname(__FILE__))

  dependency 'merb-slices', :immediate => true
  dependency 'lpl-core',    :immediate => true
  
  Merb::Plugins.add_rakefiles "<%= base_name %>/merbtasks", "<%= base_name %>/extensiontasks", "<%= base_name %>/spectasks"

  # Register a namespace for the views.
  Object.make_module("Views::<%= module_name %>")
  
  # Load the primary layout view.
  load dirname / '..' / 'app' / 'views' / 'layout' / '<% symbol_name %>.html.lrb'

  # Register the Slice for the current host application
  Merb::Slices::register(__FILE__)
  
  # LplExtension configuration - set this in a before_app_loads callback.
  # By default the main layout of LplCore is used.
  Merb::Slices::config[:<%= symbol_name %>][:layout] ||= :<%= symbol_name %>
  
  # You can set the default slice route prefix here.
  Merb::Slices::config[:<%= symbol_name %>][:path_prefix] ||= '<%= base_name %>'
  
  # Set the image to display in LplCore's layout header - using relative path;
  # if not set it won't be shown in the interface
  Merb::Slices::config[:<%= symbol_name %>][:icon] ||= 'header-icon.png'
  
  # List all extension javascripts here - the array items are passed as args to require_js
  Merb::Slices::config[:<%= symbol_name %>][:javascripts] ||= %w[master]

  # List all extension stylesheets here - the array items are passed as args to require_css
  Merb::Slices::config[:<%= symbol_name %>][:stylesheets] ||= %w[master]
  
  # Some general settings/metadata
  Merb::Slices::config[:<%= symbol_name %>][:info] ||= {}
    
  # All Slice code is expected to be namespaced inside a module
  module <%= module_name %>
    
    # Slice metadata
    self.description = "<%= module_name %> is a chunky LplExtension!"
    self.version = "0.0.1"
    self.author = "Your name"
    
    def self.icon
      ::<%= module_name %>.public_path_for(:image, self[:icon])
    end
    
    def self.icon?
      self.config.key?(:icon)
    end
    
    # Stub classes loaded hook - runs before LoadClasses BootLoader
    # right after a slice's classes have been loaded internally.
    def self.loaded
      LplCore.load_extension(self)
    end
    
    # Initialization hook - runs before AfterAppLoads BootLoader
    def self.init
      LplCore.init_extension(self)
    end
    
    # Activation hook - runs after AfterAppLoads BootLoader
    def self.activate
      LplCore.activate_extension(self)   
    end
    
    # Deactivation hook - triggered by Merb::Slices.deactivate(Fooz)
    def self.deactivate
      LplCore.deactivate_extension(self)
    end
    
    # Setup routes inside the host application
    #
    # @param scope<Merb::Router::Behaviour>
    #  Routes will be added within this scope (namespace). In fact, any 
    #  router behaviour is a valid namespace, so you can attach
    #  routes at any level of your router setup.
    #
    # @note prefix your named routes with :<%= symbol_name %>_
    #   to avoid potential conflicts with global named routes.
    def self.setup_router(scope)
      # a route named :index is mandatory for extensions that appear in the header
      scope.match('(/index)(.:format)').to(:controller => 'main', :action => 'index').name(:index)
      # enable slice-level default routes by default
      scope.default_routes
    end
    
  end
  
  # Setup the slice layout for <%= module_name %>
  #
  # Use <%= module_name %>.push_path and <%= module_name %>.push_app_path
  # to set paths to <%= base_name %>-level and app-level paths. Example:
  #
  # <%= module_name %>.push_path(:application, <%= module_name %>.root)
  # <%= module_name %>.push_app_path(:application, Merb.root / 'slices' / '<%= base_name %>')
  # ...
  #
  # Any component path that hasn't been set will default to <%= module_name %>.root
  #
  # Or just call setup_default_structure! to setup a basic Merb MVC structure.
  <%= module_name %>.setup_default_structure!
  
  # Add dependencies for other <%= module_name %> classes below. Example:
  # dependency "<%= base_name %>/other"
  
end