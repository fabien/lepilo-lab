class Views::LplViewSample::Show < LplView::View
  
  def buttons
    vars[:buttons] || []
  end
  
  def render
    header
    super
    footer
  end
  
  def header
    builder.ul do |ul|
      buttons.each do |button|
        ul.li { self << button }        
      end
    end
  end
  
  def footer
    builder.hr
    builder.strong(vars[:ivar_value]) if vars[:ivar_value]
  end

end