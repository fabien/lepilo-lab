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
      
      def append_query_params(qp)
        request.path + '?' + request.send(:query_params).merge(qp).to_params
      end
      
      module ClassMethods
        
        def core
          LplCore::Proxy
        end
        
        protected
        
        def require_authentication
          before :ensure_authenticated
        end

        def require_core_assets
          before { core.require_assets }
        end
        
      end
      
    end
  end
end