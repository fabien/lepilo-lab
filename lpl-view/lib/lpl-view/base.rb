module LplView
  
  TEMPLATE_EXT_REGEXP = /(\.(html|xml|json|js|text))?\.rb$/
  
  def self.template_lookup
    @@template_lookup ||= {}
  end
  
  class Base
    
    attr_reader :_template
    
    # You can specify before/after hooks for the #render method.
    # Feel free to add additional hooks for methods you add.
    # Syntax: register_instance_hooks :your_method 
    # (after the method has been defined)
    include Extlib::Hook

    # Be sure to call #super from your subclassed #initialize method.
    def initialize(*args, &block)
      @render_inner_proc = block
    end

    # Returns the XmlMarkup builder instance to operate on.
    def builder
      @builder ||= Builder::XmlMarkup.new(:indent => 2)
    end

    # Appending to this object will append raw String values or the
    # result of :to_html calls - if available, builder will be adjusted
    # to respect the current indentation level.
    def concat(obj)
      if obj.respond_to?(:to_html)
        obj.builder.level = builder.level if obj.respond_to?(:builder)
        builder << obj.to_html
      else
        builder << indent(obj.to_s)
      end
    end
    alias :<< :concat

    # This method will trigger rendering and return the html string.
    # If :halt is thrown during #render the thrown value is used
    # to generate output instead. Some examples:
    #
    # throw(:halt) => no output, empty String
    # throw(:halt, 'Awesome - you broke it!') => String value
    # throw(:halt, :some_method) => execute #some_method
    # throw(:halt, lambda { .. }) => the result of evaluating the lambda
    #
    def to_html
      caught = catch(:halt) { render; true }
      html = case caught
        when nil    then ''
        when String then caught
        when Symbol then send(caught).to_s
        when Proc   then self.instance_eval(&caught).to_s
        else builder.target!
      end
      reset!
      html
    rescue NameError => e
      handle_exception(e)
    end
    alias :to_s :to_html
    
    # This is a stub method to generate an xml representation.
    # It will be used for templates like: index.xml.rb
    def to_xml
    end
    
    # This is a stub method to generate a json representation.
    # It will be used for templates like: index.json.rb
    def to_json
    end
    
    # This is a stub method to generate a js/ajax representation.
    # It will be used for templates like: index.js.rb
    def to_js
    end
    
    # This is a stub method to generate a js/ajax representation.
    # It will be used for templates like: index.text.rb
    def to_text
    end
    
    # Assign instance variables from Hash; optionally supply context for
    # helper method delegation.
    def assign(hsh, context = nil)
      self.context = context unless context.nil?
      if hsh.respond_to?(:each_pair)
        @_template = hsh[:_template]
        self.assigns.clear
        hsh.each_pair do |key, value|
          next if key.to_s =~ /^_/
          self.assigns << (ivar = "@#{key}")
          instance_variable_set(ivar, value)
        end
      end
    end
    
    # Controller instance variables are tracked, so they can be reset later.
    def assigns
      @assigns ||= []
    end
    
    def context=(target)
      @context = target
    end
    
    def context
      @context ||= self
    end
    
    def inspect
      "#<#{self.class.name} assigns=#{assigns.inspect} context=#{context.class}>"
    end

    protected

    # This is the method you should override; you can take advantage
    # of rendering the block that has been passed at #initialize
    # by calling super from your subclassed #render method.
    def render
      render_inner
    end
    
    # This method is called when method_missing can't find a suitable
    # assigned variable or helper method.
    def failure(msg = nil)
      msg = "Error in #{self.class}" if msg.nil?
      "<strong style=\"color: red\">#{msg.to_xs}</strong>"
    end

    def indent(str, increment = 0)
      str.gsub(/(^|\n( +)?$)/, "#{indentation(increment)}\\1")
    end
    
    def indentation(increment = 0)
      ' ' * ((builder.level + increment) * builder.indent)
    end

    private

    # Render the block that has been set from #initialize;
    # it recieves the view/widget instance.
    def render_inner
      if @render_inner_proc.respond_to?(:call)
        @render_inner_proc.call(self)
      end
    end

    # Reset the builder - a subsequent render call will have a new instance 
    # of Builder::XmlMarkup created. Assigned variables are cleared.
    def reset!
      @builder = nil
      self.assigns.each do |ivar|
        next unless instance_variable_defined?(ivar)
        remove_instance_variable(ivar)
      end
    end
    
    def method_missing(method_name, *args, &block)
      if context.respond_to?(method_name)
        self.class.send(:define_method, method_name) do
          context.send(method_name, *args, &block)
        end
        send(method_name)
      elsif assigns.include?(ivar = "@#{method_name}")
        instance_variable_get(ivar)
      elsif caller.first.match(/\.lpl$/)
        nil
      else        
        super
      end          
    end
    
    def handle_exception(exception)
      failure(exception.message)
    end
    
    def self.inherited(klass)
      template_path = File.expand_path(caller.first.sub(/:\d+$/, ''))
      if template_path =~ ::LplView::TEMPLATE_EXT_REGEXP
        ::LplView.template_lookup[template_path] = klass
      end
    end

    register_instance_hooks :render

  end
end