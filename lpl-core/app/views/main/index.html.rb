module Views
  module LplCore
    module Main      
      class Index < Views::LplCore::Main::Base
        
        def render
          builder.h1 "Hello From #{self.class.name}"
        end
        
      end      
    end
  end
end