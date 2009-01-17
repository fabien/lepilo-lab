module Views
  module LplViewSample
    class Halt < LplView::View
  
      def render
        builder.h1 "Hello World"
        throw(:halt, lambda { "FAIL! Say whut?! (at #{_template})" })
      end
      
    end
  end
end