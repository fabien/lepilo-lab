module Merb::Template
  class LplViewHandler

    # Defines a method for calling a specific Erector class.
    #
    # ==== Parameters
    # path<String>:: Path to the template file.
    # name<~to_s>:: The name of the template method.
    # locals<Array[Symbol]>:: A list of locals to assign from the args passed into the compiled template.
    # mod<Class, Module>::
    #   The class or module wherein this method should be defined.
    def self.compile_template(io, name, locals, mod)
      path = File.expand_path(io.path)
      
      path_parts = path.split('/')
      path_views_idx = path_parts.index('views') + 1
      
      relative_path_parts = path_parts[path_views_idx, path_parts.length - path_views_idx]
      is_partial = relative_path_parts.last =~ /^_/
      
      # Load the class file from path.
      load(path)
      
      view_class_name = if Merb.env?(:development)
        ::LplView.template_lookup[path]        
      else
        ::LplView.template_lookup[path] || 'Merb::Template::LplViewHandler::Failure'
      end
      
      raise 'LplView could not determine the class of the requested template' if view_class_name.nil?
      
      code = <<-CODE
        def #{name}(_lpl_view_locals={})
          @_engine = 'lpl_view'
          
          assigns = instance_variables.inject({}) do |hash, name|
            hash[name.tr('@', '')] = instance_variable_get(name)
            hash
          end
          
          assigns[:_template] = #{path.inspect}
          
          view = if thrown_content?(:for_layout)
            ::#{view_class_name}.new { |builder| builder << catch_content(:for_layout) }
          else
            ::#{view_class_name}.new
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
        LplView::Widget.new(&block)
      end
      
      def view(&block)
        LplView::View.new(&block)
      end
      
    end
    
    Merb::Template.register_extensions(self, %w[rb]) 
    
    class Failure < LplView::Widget
      
      def render
        self << failure("LplView could not determine the class of the requested template")
      end
      
    end
  
  end
end
