require 'rubygems'
require 'extlib'

module LplSupport
  
  def self.mimetype_locales # Load EU locales by default
    @mimetype_locales ||= %w[da de es fi fr it nl nn no pl pt sl sv]
  end
  
  def self.mimetype_locales=(*locales)
    self.replace(locales.flatten)
  end
  
end

Object.make_module("LplSupport::Merb::Controller::Mixins")

$:.unshift File.dirname(__FILE__)
require 'lpl-support/core' # other parts are optional - require them explicitly