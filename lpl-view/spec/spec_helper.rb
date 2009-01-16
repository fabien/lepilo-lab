$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require "rubygems"
require "merb-core"
require "spec"

require "lpl-view"

class Button < LplView::Widget
  
  attr_accessor :label, :url
  
  def initialize(label, url, &block)
    super
    @label, @url = label, url
  end
  
  def render
    builder.a(label, :href => url)
  end
  
end

Merb.start_environment(:merb_root => File.dirname(__FILE__), :environment => 'test', :adapter => 'runner')

Spec::Runner.configure do |config|
  config.include Merb::Test::RequestHelper  
end

