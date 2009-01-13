if defined?(Merb::Plugins)

  $:.unshift File.dirname(__FILE__)

  dependency 'merb-slices', :immediate => true
  dependency 'merb-auth-slice-password'
  
  Merb::Plugins.add_rakefiles "lpl-core/merbtasks", "lpl-core/slicetasks", "lpl-core/spectasks"
  
  require 'lpl-core' / 'support' / 'merb-slices' / 'module_mixin'

  # Register the Slice for the current host application
  Merb::Slices::register(__FILE__)
  
  # Slice configuration - set this in a before_app_loads callback.
  # By default a Slice uses its own layout, so you can swicht to 
  # the main application layout or no layout at all if needed.
  # 
  # Configuration options:
  # :layout - the layout to use; defaults to :lpl-core
  # :mirror - which path component types to use on copy operations; defaults to all
  Merb::Slices::config[:lpl_core][:layout]      ||= :lpl_core
  Merb::Slices::config[:lpl_core][:path_prefix] ||= 'core'
  
  # All Slice code is expected to be namespaced inside a module
  module LplCore
    
    # Slice metadata
    self.description = "LplCore is a chunky Merb slice!"
    self.version = "0.0.1"
    self.author = "Engine Yard"
    
    # Stub classes loaded hook - runs before LoadClasses BootLoader
    # right after a slice's classes have been loaded internally.
    def self.loaded
    end
    
    # Initialization hook - runs before AfterAppLoads BootLoader
    def self.init
    end
    
    # Activation hook - runs after AfterAppLoads BootLoader
    def self.activate
    end
    
    # Deactivation hook - triggered by Merb::Slices.deactivate(LplCore)
    def self.deactivate
    end
    
    # Setup routes inside the host application
    #
    # @param scope<Merb::Router::Behaviour>
    #  Routes will be added within this scope (namespace). In fact, any 
    #  router behaviour is a valid namespace, so you can attach
    #  routes at any level of your router setup.
    #
    # @note prefix your named routes with :lpl_core_
    #   to avoid potential conflicts with global named routes.
    def self.setup_router(scope)
      # example of a named route
      scope.match('/index(.:format)').to(:controller => 'main', :action => 'index').name(:index)
      # the slice is mounted at /lpl-core - note that it comes before default_routes
      scope.match('/').to(:controller => 'main', :action => 'index').name(:home)
      # enable slice-level default routes by default
      scope.default_routes
    end
    
    def self.extensions
      @@extensions ||= Set.new
    end
    
  end
  
  # Setup the slice layout for LplCore
  #
  # Use LplCore.push_path and LplCore.push_app_path
  # to set paths to lpl-core-level and app-level paths. Example:
  #
  # LplCore.push_path(:application, LplCore.root)
  # LplCore.push_app_path(:application, Merb.root / 'slices' / 'lpl-core')
  # ...
  #
  # Any component path that hasn't been set will default to LplCore.root
  #
  # Or just call setup_default_structure! to setup a basic Merb MVC structure.
  LplCore.setup_default_structure!
  
  # Add dependencies for other LplCore classes below. Example:
  # dependency "lpl-core/other"
  
end