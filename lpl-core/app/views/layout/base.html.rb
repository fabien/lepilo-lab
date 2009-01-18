module Views
  module LplCore
    module Layout
      class Base < LplView::View
        
        def initialize(*args, &block)
          @show_sidebar = @show_feedback = @show_inspector = @show_shelf = true
          super
        end
  
        def render
          doctype!
          builder.html(:xmlns => "http://www.w3.org/1999/xhtml") do |html|
            html.head { render_head }
            html.body { render_body }
          end
        end

        def render_head
          builder.meta(:"http-equiv" => "content-type", :content => "text/html; charset=utf-8")
          builder.title page_title
          insert_metadata
          insert_required_assets
          insert_inline_code
        end

        def render_body
          builder.div(:id => 'container') do |container|
            container.div(:id => 'lpl_core_main')       { render_main       }
            container.div(:id => 'lpl_core_header')     { render_header     }
            container.div(:id => 'lpl_core_sidebar')    { render_sidebar    } if show_sidebar?
            container.div(:id => 'lpl_core_feedback')   { render_feedback   } if show_feedback?
            container.div(:id => 'lpl_core_inspector')  { render_inspector  } if show_inspector?
            container.div(:id => 'lpl_core_shelf')      { render_shelf      } if show_shelf?
          end
        end
        
        # Methods to implement - using builder to append markup.
        def render_main; render_inner;  end
        def render_header;              end
        def render_sidebar;             end
        def render_feedback;            end
        def render_inspector;           end
        def render_shelf;               end
        
        protected
        
        def insert_metadata
          builder.meta(:name => 'description',  :content => page_description)
          builder.meta(:name => 'keywords',     :content => page_keywords)
          builder.meta(:name => 'copyright',    :content => page_copyright)
          builder.meta(:name => 'author',       :content => page_author)
          builder.meta(:name => 'generator',    :content => page_generator)
        end
        
        def insert_required_assets
          self << include_required_css
          self << include_required_js
        end
        
        def insert_inline_code
          self << include_inline_css
          self << include_inline_js
        end
        
        # Methods to implement to determine which parts of the layout are visible.
        def show_sidebar?;    @show_sidebar;     end        
        def show_feedback?;   @show_feedback;    end
        def show_inspector?;  @show_inspector;   end
        def show_shelf?;      @show_shelf;       end

      end
    end
  end
end