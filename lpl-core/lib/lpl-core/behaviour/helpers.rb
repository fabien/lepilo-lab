module LplCore
  module Behaviour
    module Helpers
      
      # This module is mixed into LplCore::Application, as well as into any
      # LplCore::Extension's Application controller. It contains functionality
      # that's usually related to the view.
      
      attr_writer :page_title, :page_description, :page_keywords
      attr_writer :page_copyright, :page_author, :page_generator
      
      def bodytag_id(prefix = '')
        "#{prefix}#{controller_name.hyphenize}-#{action_name.hyphenize}"
      end

      def bodytag_classname
        "#{slice.name.hyphenize} #{controller_name.hyphenize}"
      end
      
      # page head/metadata
      
      def core_info
        ::LplCore[:info] || {}
      end
      
      def info
        @_info ||= core_info.merge(self.slice[:info] || {})
      end
      
      def page_title
        (Array(info[:title]) + Array(@page_title)).flatten.compact.join(' • ')
      end
      
      def page_description
        @page_description || info[:description]
      end
      
      def page_keywords
        (Array(info[:keywords]) + Array(@page_keywords || [])).join(', ')
      end
      
      def page_copyright
        @page_copyright || info[:copyright]
      end
      
      def page_author
        @page_generator || info[:author]
      end
      
      def page_generator
        @page_generator || info[:generator]
      end
      
      # asset handling
      
      def insert_css(string = nil, &block)
        if self.slice == LplCore
          throw_content(:core_inline_css, string, &block)
        elsif self.is_a?(::LplCore::Extension)
          throw_content(:extension_inline_css, string, &block)
        else
          throw_content(:inline_css, string, &block)
        end
      end

      def insert_js(string = nil, &block)
        if self.slice == LplCore
          throw_content(:core_inline_js, string, &block)
        elsif self.is_a?(::LplCore::Extension)
          throw_content(:extension_inline_js, string, &block)
        else
          throw_content(:inline_js, string, &block)
        end
      end
      
      def include_inline_css(options = {})
        opts = { :type => 'text/css', :media => 'all' }.merge(options)
        [:core_inline_css, :extension_inline_css, :inline_css].inject([]) do |acc, type|
          if thrown_content?(type)
            acc << "<!-- #{type} -->"
            acc << tag(:style, catch_content(type), opts.merge(options[type] || {}))
          end
          acc
        end.join("\n")
      end
      
      def include_inline_js(options = {})
        opts = { :type => 'text/javascript', :charset => 'utf-8' }.merge(options)
        [:core_inline_js, :extension_inline_js, :inline_js].inject([]) do |acc, type|
          if thrown_content?(type)
            acc << "<!-- #{type} -->"
            acc << tag(:script, catch_content(type), opts.merge(options[type] || {}))
          end
          acc
        end.join("\n")
      end
      
      def require_core_assets
        ::LplCore[:javascripts].each { |args| require_core_js(*args)  }
        ::LplCore[:stylesheets].each { |args| require_core_css(*args) }
      end
      
      def require_core_js(*js)
        js.flatten!
        options = js.last.is_a?(Hash) ? js.pop : {}
        assets = js.map { |asset| core_javascript_path("#{asset}.js") }
        require_js(*(assets << options))
      end
      
      def require_core_css(*css)
        css.flatten!
        options = css.last.is_a?(Hash) ? css.pop : {}
        assets = css.map { |asset| core_stylesheet_path("#{asset}.css") }
        require_css(*(assets << options))
      end
      
      # paths to the LplCore slice
      
      def core_image_path(*segments)
        core_public_path_for(:image, *segments)
      end
      
      def core_javascript_path(*segments)
        core_public_path_for(:javascript, *segments)
      end
      
      def core_stylesheet_path(*segments)
        core_public_path_for(:stylesheet, *segments)
      end
      
      def core_public_path_for(type, *segments)
        ::LplCore.public_path_for(type, *segments)
      end
      
      def core_app_path_for(type, *segments)
        ::LplCore.app_path_for(type, *segments)
      end
      
      def core_slice_path_for(type, *segments)
        ::LplCore.slice_path_for(type, *segments)
      end
      
    end
  end
end