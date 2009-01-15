module LplCore
  module ExtensionHelper
    
    # This module is mixed into LplCore::Extension - it adds helpers specific
    # to Extension controllers; also, it includes GlobalHelper for any shared
    # helpers.
  
    def self.included(base)
      base.send(:include, Merb::LplCore::GlobalHelper)
      
      puts "included ExtensionHelper in #{base}"
    end
   
  end
end