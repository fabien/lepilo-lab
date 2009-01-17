module Views
  module <%= module_name %>
    module Main      
      class Index < LplView::View
        
        def render
          builder.h1 "#{slice.name} (#{slice.version})"
          builder.p slice.description
        end
        
      end      
    end
  end
end