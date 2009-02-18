# This monkey patch will make sure merb-auth-slice-password won't interfere 
# with the customize_default done here (it will unshift instead of push)
module Merb
  class Authentication
    def self.customize_default(&block)
      default_customizations.unshift(block)
      default_customizations
    end
  end
end

Merb::Authentication.customize_default do
  Exceptions.class_eval do
    
    include LplCore::Behaviour::Controller
    include LplCore::Behaviour::Helpers
        
    controller_for_slice LplCore, :layout => LplCore[:exceptions_layout] || :application
    
    alias :app_unauthenticated :unauthenticated
    
    # handle Unauthenticated exceptions from merb-auth
    def unauthenticated
      return app_unauthenticated unless core.request?
      
      provides :xml, :js, :json, :yaml
      case content_type
      when :html
        render_core_exception :unauthenticated
      else
        basic_authentication.request!
        ""
      end
    end
    
    alias :app_not_found :not_found
    
    # handle NotFound exceptions (404)
    def not_found
      return app_not_found unless core.request?
      render_core_exception :not_found
    end
    
    alias :app_not_acceptable :not_acceptable
    
    # handle NotAcceptable exceptions (406)
    def not_acceptable
      return app_not_acceptable unless core.request?
      render_core_exception :not_acceptable
    end
    
    protected
    
    def render_core_exception(exception_action_name)
      core.require_assets
      core.hide_sidebar!
      core.hide_inspector!
      core.hide_shelf!
      render :template => "exceptions/lpl_#{exception_action_name}", :layout => :exceptions
    end
    
  end
end