module Views
  module LplViewSample
    class Partials < LplView::View
  
      def render
        builder.h1 'View with partials'
        self << partial('partial', :ivar => 'A')
        self << partial('partial', :ivar => 'B')
      end

    end
  end
end