class <%= module_name %>::Application < Merb::Controller
  
  # Enable Slice behaviour
  controller_for_slice :templates_from => LplCore
  
  # By default authentication is required
  before :ensure_authenticated
  
end