if defined?(Merb::Plugins)

  $:.unshift(dirname = File.dirname(__FILE__))

  dependency 'lpl-support', '0.0.1', :immediate => true
  dependency 'lpl-view', '0.0.1', :immediate => true
  dependency 'merb-slices', '>= 1.0.8.1', :immediate => true
  dependency 'merb-auth-slice-password', '>= 1.0.8.1', :immediate => true
  
  Merb::Plugins.add_rakefiles "lpl-core/merbtasks", "lpl-core/slicetasks", "lpl-core/spectasks"
  
  # Register a namespace for the views.
  Object.make_module("Views::LplCore")
  
  # Load specific LplSupport functionality.
  require 'lpl-support' / 'merb' / 'controller' / 'mixins' / 'response_handling'
  
  # Load essential LplCore classes.
  require dirname / 'lpl-core' / 'support'
  require dirname / 'lpl-core' / 'proxy'
  require dirname / 'lpl-core' / 'behaviour'
  require dirname / 'lpl-core' / 'extension'
  require dirname / 'lpl-core' / 'view_helpers'
  require dirname / 'lpl-core' / 'transfigr'
  
  # Load the base layouts so extensions can inherit from them
  require dirname / '..' / 'app' / 'views' / 'layout' / 'base.html.rb'
  require dirname / '..' / 'app' / 'views' / 'layout' / 'main.html.rb'
  
  # Load the base templates so extensions can inherit from them
  require dirname / '..' / 'app' / 'views' / 'main' / 'base.html.rb'
  
  # Mixin the view helpers for the base layout and template.
  Views::LplCore::Layout::Base.send(:include, LplCore::ViewHelpers)
  Views::LplCore::Main::Base.send(:include, LplCore::ViewHelpers)
  
  # Register the Slice for the current host application
  Merb::Slices::register(__FILE__)
  
  # Slice configuration - set this in a before_app_loads callback.
  # By default a Slice uses its own layout, so you can swicht to 
  # the main application layout or no layout at all if needed.
  # 
  # Configuration options:
  # :layout       - the layout to use; defaults to :lpl-core
  # :mirror       - which path component types to use on copy operations; defaults to all
  # :path_prefix  - what path to use in the slice's url
  Merb::Slices::config[:lpl_core][:prefix]      ||= 'lepilo'
  Merb::Slices::config[:lpl_core][:layout]      ||= :main
  Merb::Slices::config[:lpl_core][:path_prefix] ||= 'core'
  
  # List all core javascripts here - the array items are passed as args to core.require_js
  Merb::Slices::config[:lpl_core][:javascripts] ||= begin
    javascripts = []
    javascripts << [%w[jquery jquery-ui jquery.cookie jquery.livequery jquery.json],  { :bundle => 'bundle.lpl.jquery' }]
    javascripts << [%w[jquery.autogrow-textarea lowpro.jquery swfupload], { :bundle => 'bundle.lpl.extensions' }]
    javascripts << [%w[lpl.support lpl.app lpl.snippets lpl.inspector lpl.shelf lpl.sidebar lpl.feedback lpl.layout lpl.modal lpl.uploadrz], { :bundle => 'bundle.lpl.app' }]
    javascripts << [%w[showdown markitup/jquery.markitup markitup/sets/markdown], { :bundle => 'bundle.markdown' }]
  end
  
  # List all core stylesheets here - the array items are passed as args to core.require_css
  Merb::Slices::config[:lpl_core][:stylesheets] ||= begin
    stylesheets = []
    stylesheets << [%w[reset lpl_base lpl_ui lpl_buttons lpl_forms lpl_content lpl_header lpl_footer lpl_modal lpl_markdown], { :bundle => 'bundle.lpl.app' }]
    stylesheets << [%w[markitup/skins/markitup/style markitup/sets/markdown/style], { :bundle => 'bundle.markdown' }]
  end
  
  # Some general settings/metadata
  Merb::Slices::config[:lpl_core][:info] ||= {}
  Merb::Slices::config[:lpl_core][:info][:title]        ||= 'lepilo • content mingler'
  Merb::Slices::config[:lpl_core][:info][:description]  ||= ''
  Merb::Slices::config[:lpl_core][:info][:keywords]     ||= ''
  Merb::Slices::config[:lpl_core][:info][:copyright]    ||= "(c) #{Date.today.year} Samo Korosec - Fabien Franzen"
  Merb::Slices::config[:lpl_core][:info][:author]       ||= "Samo Korosec - Fabien Franzen"
  Merb::Slices::config[:lpl_core][:info][:generator]    ||= Merb::Slices::config[:lpl_core][:info][:title]
  
  # All Slice code is expected to be namespaced inside a module
  module LplCore
    
    # Slice metadata
    self.description = "LplCore is a chunky Merb slice!"
    self.version = "0.0.1"
    self.author = "Samo Korosec - Fabien Franzen"
    
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
    
    # Extension loaded hook - runs before LoadClasses BootLoader
    def self.load_extension(extension)
    end
    
    # Extension initialization hook - runs before AfterAppLoads BootLoader
    def self.init_extension(extension)
    end
    
    # Extension activation hook - runs after AfterAppLoads BootLoader
    def self.activate_extension(extension)
      self.extensions.add(extension)
    end
    
    # Extension deactivation hook - triggered by Merb::Slices.deactivate(extension)
    def self.deactivate_extension(extension)
      self.extensions.delete(extension)
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