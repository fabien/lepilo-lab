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
        
    controller_for_slice LplCore, :layout => :application
    
    # handle Unauthenticated exceptions from merb-auth
    def unauthenticated
      provides :xml, :js, :json, :yaml
      case content_type
      when :html
        if core.request?
          render_core_exception :unauthenticated
        else
          render
        end
      else
        basic_authentication.request!
        ""
      end
    end
    
    # handle NotFound exceptions (404)
    def not_found
      # Check whether the request is made within lpl or simply at the site-level
      if core.request?
        render_core_exception :not_found
      else
        render :format => :html
      end
    end
    
    # handle NotAcceptable exceptions (406)
    def not_acceptable
      # Check whether the request is made within lpl or simply at the site-level
      if core.request?
        render_core_exception :not_acceptable
      else
        render :format => :html
      end
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