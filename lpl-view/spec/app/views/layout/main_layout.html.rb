module Views
  module LayoutViewSample
    class MainLayout < LplView::View
  
      def render
        builder.h3 "BEFORE CONTENT"
        builder.hr
        super # similar to catch_content(:for_layout)
        builder.hr
        builder.h3 "AFTER CONTENT"
      end
      
    end
  end
end