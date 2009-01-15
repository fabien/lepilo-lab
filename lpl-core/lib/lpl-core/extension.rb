require 'lpl-core/extension/helper'

module LplCore
  class Extension < Merb::Controller
    
    include LplCore::ExtensionHelper
    
    def self.setup_extension(slice_module = nil, options = {})
      controller_for_slice(slice_module, { :templates_from => LplCore }.merge(options))
    end
    
  end
end