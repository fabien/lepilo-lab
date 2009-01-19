# Go to http://wiki.merbivore.com/pages/init-rb
 
require 'config/dependencies.rb'

#  use_orm :none
use_test :rspec
use_template_engine :erb
 
Merb::Config.use do |c|
  c[:use_mutex] = false
  c[:session_store] = 'cookie'  # can also be 'memory', 'memcache', 'container', 'datamapper
  
  # cookie session store configuration
  c[:session_secret_key]  = '296fb4131c92bfbe7d400fc9777f47fb9cb8df67'  # required for cookie session store
  c[:session_id_key] = '_lpl_session_id' # cookie session id key, defaults to "_session_id"
end
 
Merb::BootLoader.before_app_loads do
  
  Merb::Plugins.config[:merb_slices][:search_path] = [Merb.root / "slices", Merb.root / "sofa"]
  
  # This option sets the url/path entry point for all slices - see router.rb
  LplCore[:prefix] = 'lepilo'
  # List extension you want to enable here - they will appear in this order in the interface.
  # In case an extension isn't found it will just be ignored, so it's safe to include
  # any extension you migh have (as a dependency) in this list.
  LplCore[:extensions] = [:fooz, :awesome, :sofa_pages]
end
 
Merb::BootLoader.after_app_loads do
  # This will get executed after your app's classes have been loaded.
end