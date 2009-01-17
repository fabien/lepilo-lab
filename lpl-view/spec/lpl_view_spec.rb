require File.dirname(__FILE__) + '/spec_helper'

describe "LplView" do
  
  it "should be able to render View templates" do
    c = dispatch_to(LplViewSample, :index)
    c.body.should == "<h1>Hello World [value of @ivar_value &amp;] (sample_helper output)</h1>\n<hr/>\n<strong>value of @ivar_value &amp;</strong>\n"
  end
  
  it "should be able to render View templates with subwidgets" do
    c = dispatch_to(LplViewSample, :show)
    c.body.should == "<h1>Rendered from lpl_view_sample/show</h1>\n<ul>\n  <li>\n    <a href=\"#a-link\">Awesome</a>\n  </li>\n  <li>\n    <a href=\"#a-link\">Excellent</a>\n  </li>\n  <li>\n    <a href=\"#some-link\">Runtime builder</a>\n  </li>\n</ul>\n<hr/>\n"
  end
  
  it "should be able to :halt rendering of View templates" do
    template = File.expand_path(File.dirname(__FILE__) / 'app' / 'views' / 'lpl_view_sample' / 'halt.html.rb')
    c = dispatch_to(LplViewSample, :halt)
    c.body.should == "FAIL! Say whut?! (at #{template})"
  end
  
  it "should offer template inheritance" do
    c = dispatch_to(LplViewSample, :inherit)
    c.body.should == "<div>\n  <h1>Hello World [some ivar value] (sample_helper output)</h1>\n</div>\n<hr/>\n<strong>some ivar value</strong>\n"
  end
  
  it "should be compatible with Merb's display API" do
    c = dispatch_to(LplViewSample, :runtime)
    c.body.should == "<h1>Created at runtime</h1>\n"
  end
  
  it "should be able to render templates in a layout view" do
    c = dispatch_to(LayoutViewSample, :index)
    c.body.should == "<h3>BEFORE CONTENT</h3>\n<hr/>\n<h1>Hello from LayoutViewSample</h1>\n<hr/>\n<h3>AFTER CONTENT</h3>\n"
  end
  
end