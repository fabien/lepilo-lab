class LplCore::Main < LplCore::Application
  
  def index
    core.close_sidebar!
    core.close_inspector!
    core.close_shelf!
    render
  end
  
end