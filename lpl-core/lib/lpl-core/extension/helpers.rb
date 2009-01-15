module LplCore
  module ExtensionHelpers
    
    # This module is mixed into LplCore::Extension - it adds helpers specific
    # to Extension controllers. It contains functionality that's usually 
    # related to the view.
  
    def self.included(base)
      puts "included ExtensionHelpers in #{base}"
    end
   
  end
end