# make sure we're running inside Merb
if defined?(Merb::Plugins)

  require "builder"
  require "lpl-view/support"
  require "lpl-view/base"
  require "lpl-view/widget"
  require "lpl-view/view"
  require "lpl-view/template"

  # Merb gives you a Merb::Plugins.config hash...feel free to put your stuff in your piece of it
  Merb::Plugins.config[:lpl_view] = { :namespace => 'Views' }
  
  Merb::BootLoader.before_app_loads do
    # setup the Module that encompasses the all Views - it will create the necessary
    # controller-level Module if it's missing.
    view_module_name = Array(Merb::Plugins.config[:lpl_view][:namespace]).join('::')
    view_module = Object.full_const_get(view_module_name) rescue nil
    Object.make_module(view_module_name) if view_module.nil?
    mod = Object.full_const_get(view_module_name)
    mod.instance_eval do
      def const_missing(const)
        self.const_set(const, ::Module)
      end      
    end    
  end
  
  Merb::BootLoader.after_app_loads do
    # code that can be required after the application loads
  end
  
  Merb::Plugins.add_rakefiles "lpl-view/merbtasks"
end