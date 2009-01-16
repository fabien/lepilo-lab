class Views::LplViewSample::Inherit < Views::LplViewSample::Index
  
  def header
    builder.div { super }
  end

end