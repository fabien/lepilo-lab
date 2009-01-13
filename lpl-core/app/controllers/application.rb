class LplCore::Application < Merb::Controller
  
  controller_for_slice
  
  before :ensure_authenticated
  
end