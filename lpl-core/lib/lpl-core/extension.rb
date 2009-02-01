require 'lpl-core/extension/helpers'

module LplCore
  class Extension < Merb::Controller
    
    include LplCore::Behaviour::Controller
    include LplCore::ExtensionHelpers
        
    def self.setup_extension(slice_module = nil, options = {})
      controller_for_slice(slice_module, { :templates_from => LplCore }.merge(options))
    end
    
    def self.require_extension_assets
      before :require_extension_assets
    end
    
    protected
    
    def require_extension_assets
      slice[:javascripts].each { |args| require_slice_js(*args)  } if slice[:javascripts]
      slice[:stylesheets].each { |args| require_slice_css(*args) } if slice[:stylesheets]
    end
    
  end
end