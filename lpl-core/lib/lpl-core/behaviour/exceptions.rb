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
        core.require_assets
        core.hide_sidebar!
        core.hide_inspector!
        core.hide_shelf!
        render :layout => :base
      else
        basic_authentication.request!
        ""
      end
    end
    
  end
end