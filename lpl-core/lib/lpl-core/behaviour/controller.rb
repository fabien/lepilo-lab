module LplCore
  module Behaviour
    module Controller
      
      # This module is mixed into LplCore::Application, as well as into any
      # LplCore::Extension's Application controller.
      
      def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, LplCore::Behaviour::Helpers)
      end
      
      module ClassMethods
        
        def require_authentication
          before :ensure_authenticated
        end

        def require_core_assets
          before :require_core_assets
        end
        
      end
      
    end
  end
end