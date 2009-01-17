class LplView::View < LplView::Base
  
  def doctype!(*args)
    builder.declare!(:DOCTYPE, :html, :PUBLIC, "-//W3C//DTD XHTML 1.0 Strict//EN", "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd")
  end
  
end