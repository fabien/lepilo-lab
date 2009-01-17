class LplViewSample < Merb::Controller
  
  def index
    @ivar_value = 'value of @ivar_value &'
    render
  end
  
  def show
    @buttons = []
    @buttons << Button.new('Awesome', "#a-link")
    @buttons << Button.new('Excellent', "#a-link")
    @buttons << LplView::Widget.new { |w| w.builder.a('Runtime builder', :href => '#some-link') }
    
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
    display widget { |w| w.builder.h1 'Created at runtime' }
  end
  
  def partials
    render
  end
  
  protected
  
  def sample_helper
    'sample_helper output'
  end
  
end

class LayoutViewSample < Merb::Controller
  
  layout :main_layout
  
  def index
    render
  end
  
end