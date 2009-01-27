module LplCore
  module ExtensionHelpers
    
    # This module is mixed into LplCore::Extension - it adds helpers specific
    # to Extension controllers. It contains functionality that's usually 
    # related to the view.
  
    def self.included(base)
      puts "LplCore::ExtensionHelpers mixed into #{base}"
    end
   
  end
end