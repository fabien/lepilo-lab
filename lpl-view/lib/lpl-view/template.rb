module Merb::Template
  class LplViewHandler

    # Defines a method for calling a specific View class.
    #
    # ==== Parameters
    # path<String>:: Path to the template file.
    # name<~to_s>:: The name of the template method.
    # locals<Array[Symbol]>:: A list of locals to assign from the args passed into the compiled template.
    # mod<Class, Module>::
    #   The class or module wherein this method should be defined.
    def self.compile_template(io, name, locals, mod)
      path = File.expand_path(io.path)
      return if File.basename(path).index('%')

      # Load the class file from path
      # Kernel.load(path)
      
      code = <<-CODE
        def #{name}(_lpl_view_locals={})
          @_engine = 'lpl_view'

          assigns = instance_variables.inject({}) do |hash, name|
            hash[name.tr('@', '')] = instance_variable_get(name)
            hash
          end
        
          assigns[:_template] = #{path.inspect}
          view_class = ::LplView.template_lookup[ assigns[:_template] ]
          
          if view_class.blank?
            begin
              Kernel.load(assigns[:_template])
            rescue => e
              Merb.logger.warn(Merb.exception(e))
              ::LplView.template_lookup[ assigns[:_template] ] = Merb::Template::LplViewHandler::Failure
            end
            unless view_class = ::LplView.template_lookup[ assigns[:_template] ]
              view_class = Merb::Template::LplViewHandler::Failure
            end
          end
          
          if view_class == Merb::Template::LplViewHandler::Failure
            Merb.logger.warn("Unknown template class: \#{assigns[:_template]}")
          end
          
          view = if thrown_content?(:for_layout)
            view_class.new { |view| view << catch_content(:for_layout) }
          else
            view_class.new
          end
        
          view.assign(assigns.merge(_lpl_view_locals), self)
        
          case content_type
          when :html then view.to_html
          when :xml  then view.to_xml
          when :json then view.to_json
          when :js   then view.to_js
          when :text then view.to_text 
          else view.to_s
          end    
        end
      CODE
          
      method = mod.is_a?(Module) ? :module_eval : :instance_eval
      mod.send(method, code)
    
      name
    end
  
    module Mixin
      
      def widget(&block)
        w = LplView::Widget.new(&block)
        w.context = self
        w
      end
      
      def view(&block)
        v = LplView::View.new(&block)
        v.context = self
        v
      end
      
    end
    
    Merb::Template.register_extensions(self, %w[lrb]) 
    
    class Failure < LplView::Widget
      
      def render
        self << failure("LplView could not determine the class of the requested template")
      end
      
    end
  
  end
end
