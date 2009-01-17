# make sure we're running inside Merb
if defined?(Merb::Plugins)

  require "builder"
  require "lpl-view/support"
  require "lpl-view/base"
  require "lpl-view/widget"
  require "lpl-view/view"
  require "lpl-view/template"

  # Merb gives you a Merb::Plugins.config hash...feel free to put your stuff in your piece of it
  Merb::Plugins.config[:lpl_view] = {}
  
  Merb::BootLoader.before_app_loads do
  end
  
  Merb::BootLoader.after_app_loads do
  end
  
  Merb::Plugins.add_rakefiles "lpl-view/merbtasks"
end
