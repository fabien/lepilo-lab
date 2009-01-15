require 'lpl-core/extension/helpers'

module LplCore
  class Extension < Merb::Controller
    
    include LplCore::Behaviour::Controller
    include LplCore::ExtensionHelpers
    
    def self.setup_extension(slice_module = nil, options = {})
      controller_for_slice(slice_module, { :templates_from => LplCore }.merge(options))
    end
    
  end
end