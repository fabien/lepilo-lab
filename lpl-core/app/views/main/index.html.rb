module Views
  module LplCore
    module Main      
      class Index < LplView::View
        
        def render
          builder.h1 "Hello From #{self.class.name}"
        end
        
      end      
    end
  end
end