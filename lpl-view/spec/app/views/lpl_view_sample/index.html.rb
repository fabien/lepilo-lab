class Views::LplViewSample::Index < LplView::View
  
  def render
    header
    super
    footer
  end
  
  def header
    builder.h1 "Hello World [#{ivar_value}] (#{sample_helper})"
  end
  
  def footer
    builder.hr
    builder.strong vars[:ivar_value]
  end

end