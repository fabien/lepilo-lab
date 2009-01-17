class LplCore::Application < Merb::Controller
  
  include LplCore::Behaviour::Controller
    
  # Enable slice Behaviour
  controller_for_slice
  
  # By default authentication is required
  # require_authentication
  
  # Load all core javascript and css requirements
  require_core_assets
  
end