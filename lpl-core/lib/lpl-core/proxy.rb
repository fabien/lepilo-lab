module LplCore
  class Proxy
    
    # This class is available from within LplCore controllers, as well as from
    # LplCore Extension controllers through the 'core' attribute.
    #
    # Most methods defined here are analogous to extension/slice instance methods
    # but in this case they apply specifically to LplCore only.
    
    attr_reader :controller, :config, :info
    
    # Layout sections can be enabled/disabled using show_section! and hide_section!
    
    [:sidebar, :feedback, :inspector, :shelf].each do |section|
      class_eval <<-CODE
        attr_accessor :show_#{section}
        def show_#{section}!; @show_#{section} = true;   end;
        def hide_#{section}!; @show_#{section} = false;  end;
      CODE
    end
    
    def initialize(controller)
      @controller = controller
      @config = LplCore.config
      @info = @config[:info] || {}
      
      # Enable all layout sections by default
      @show_sidebar = @show_feedback = @show_inspector = @show_shelf = true
    end
    
    def extension(name)
      Merb::Slices[name.to_s.camel_case]
    end
    
    def extensions
      @@extensions ||= begin
        if config[:extensions].is_a?(Array)
          # ordered by LplCore[:extensions] = [:ext_a, :ext_b]
          config[:extensions].map { |name| extension(name) }.compact
        else
          # unordered - by load order
          LplCore.extensions
        end
      end
    end
    
    def [](key)
      self.config[key]
    end
    
    def url(*args)
      opts = args.last.is_a?(Hash) ? args.pop : {}
      route_name = args[0].is_a?(Symbol) ? args.shift : :index      
      routes = Merb::Slices.named_routes[:lpl_core]
      unless routes && route = routes[route_name]
        raise Merb::Router::GenerationError, "Named route not found: #{route_name}"
      end      
      args.push(opts)
      route.generate(args)
    end
    
    def require_assets
      self[:javascripts].each { |args| require_js(*args)  }
      self[:stylesheets].each { |args| require_css(*args) }
    end
    
    def require_js(*js)
      js.flatten!
      options = js.last.is_a?(Hash) ? js.pop : {}
      assets = js.map { |asset| javascript_path("#{asset}.js") }
      controller.require_js(*(assets << options))
    end
    
    def require_css(*css)
      css.flatten!
      options = css.last.is_a?(Hash) ? css.pop : {}
      assets = css.map { |asset| stylesheet_path("#{asset}.css") }
      controller.require_css(*(assets << options))
    end
    
    def image_path(*segments)
      public_path_for(:image, *segments)
    end
    
    def javascript_path(*segments)
      public_path_for(:javascript, *segments)
    end
    
    def stylesheet_path(*segments)
      public_path_for(:stylesheet, *segments)
    end
    
    def public_path_for(type, *segments)
      LplCore.public_path_for(type, *segments)
    end
    
    def app_path_for(type, *segments)
      LplCore.app_path_for(type, *segments)
    end
    
    def slice_path_for(type, *segments)
      LplCore.slice_path_for(type, *segments)
    end
    
    # delegation back to controller
    
    def method_missing(method, *args, &block)
      if @controller.respond_to?(method)
        @controller.send(method, *args, &block)
      else
        super
      end
    end
    
  end
end