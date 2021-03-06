module LplCore
  module Behaviour
    module Controller
      
      # This module is mixed into LplCore::Application, as well as into any
      # LplCore::Extension's Application controller.
      
      def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, LplCore::Behaviour::Helpers)
      end
      
      protected
      
      def core
        @_core ||= LplCore::Proxy.new(self)
      end
      
      module ClassMethods
        
        def core
          LplCore::Proxy
        end
        
        protected
        
        def require_authentication(opts = {})
          before(:ensure_authenticated, opts)
        end

        def require_core_assets(opts = {})
          before(nil, opts) { core.require_assets }
        end
        
      end
      
    end
  end
end