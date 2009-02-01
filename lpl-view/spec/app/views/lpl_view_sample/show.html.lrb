module Views
  module LplViewSample
    class Show < LplView::View
  
      def buttons
        @buttons || []
      end
  
      def render
        header
        super
        footer
      end
  
      def header
        builder.h1 "Rendered from #{controller_name}/#{action_name}"
        builder.ul do |ul|
          buttons.each do |button|
            ul.li { self << button }        
          end
        end
      end
  
      def footer
        builder.hr
        builder.strong(@ivar_value) if @ivar_value
      end

    end
  end
end