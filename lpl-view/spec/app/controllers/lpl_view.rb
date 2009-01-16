class LplViewSample < Merb::Controller
  
  def index
    @ivar_value = 'value of @ivar_value &'
    render
  end
  
  def show
    @buttons = []
    @buttons << Button.new('Awesome', "#a-link")
    @buttons << Button.new('Excellent', "#a-link")
    @buttons << LplView::Widget.new { |b| b.a('Runtime builder', :href => '#some-link') }
    
    render
  end
  
  def halt
    render
  end
  
  def inherit
    @ivar_value = 'some ivar value'
    render
  end
  
  def runtime
    display widget { |builder| builder.h1 'Created at runtime' }
  end
  
  protected
  
  def sample_helper
    'sample_helper output'
  end
  
end

class PartialViewSample < LplViewSample
end