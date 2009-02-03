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
  Sofa::Storage[:default] = "http://localhost:5984/lpl-app" if Object.const_defined?(:Sofa)
    
  # This option sets the url/path entry point for all slices - see router.rb
  LplCore[:prefix] = 'lepilo'
  # List extension you want to enable here - they will appear in this order in the interface.
  # In case an extension isn't found it will just be ignored, so it's safe to include
  # any extension you migh have (as a dependency) in this list.
  LplCore[:extensions] = [:fooz, :awesome, :sofa_pages]
end
 
Merb::BootLoader.after_app_loads do
  # This will get executed after your app's classes have been loaded.
    
  if Object.const_defined?(:Sofa)
    Merb::Slices::config[:sofa_pages][:sections] = %w[home nieuws]
    Merb::Slices.config[:sofa_pages][:archive_section] = 'archief'
    
    Date::DEFAULT_FORMATTING.replace '%d-%m-%Y'
    Time::DEFAULT_FORMATTING.replace '%d-%m-%Y %H:%M:%S'
    DateTime::DEFAULT_FORMATTING.replace '%d-%m-%Y %H:%M:%S'
  end


  # Enable JS and CSS compression/bundling.
  require 'lpl-support/util/cssmin'; require 'lpl-support/util/jsmin'
  Merb::Assets::JavascriptAssetBundler.add_callback { |filename| Jsmin.new(File.read(filename)).write(filename)  if File.exists?(filename) }
  Merb::Assets::StylesheetAssetBundler.add_callback { |filename| Cssmin.new(File.read(filename)).write(filename) if File.exists?(filename) }
end