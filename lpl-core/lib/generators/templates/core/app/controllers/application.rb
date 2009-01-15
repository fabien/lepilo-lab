class <%= module_name %>::Application < LplCore::Extension
  
  # Setup the extension
  setup_extension
  
  # By default authentication is required
  require_authentication
  
  # Load all core javascript and css requirements
  require_core_assets
  
end