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
      
      relative_path_parts = path.split('/')[-2,2]
      is_partial = relative_path_parts.last =~ /^_/
      
      namespace = Merb::Plugins.config[:lpl_view][:namespace] ? Array(Merb::Plugins.config[:lpl_view][:namespace]) : ['Views']
      
      view_class_parts = relative_path_parts.inject(namespace) do |class_parts, node|
        class_parts << node.gsub(/^_/, "").gsub(/(\.html)?\.rb$/, '').to_const_string
        class_parts
      end
      
      view_module_name = view_class_parts[0, view_class_parts.length - 1].join("::")
      view_class_name = view_class_parts.join("::")
      method = mod.is_a?(Module) ? :module_eval : :instance_eval
      
      view_module = Object.full_const_get(view_module_name) rescue nil
      Object.make_module(view_module_name) if view_module.nil?
      
      view_class = Object.full_const_get(view_class_name) rescue nil
      mod.send(method, io.read, path) if view_class.nil?
      
      code = <<-CODE
        def #{name}(_lpl_view_locals={})
          @_engine = 'lpl_view'
          
          assigns = instance_variables.inject({}) do |hash, name|
            hash[name.tr('@', '')] = instance_variable_get(name)
            hash
          end
          
          view = ::#{view_class_name}.new
          view.assign(assigns.merge(_lpl_view_locals), self)
          view.to_html        
        end
      CODE
            
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
  
  end
end
