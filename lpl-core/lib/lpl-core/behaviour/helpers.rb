module LplCore
  module Behaviour
    module Helpers
      
      # This module is mixed into LplCore::Application, as well as into any
      # LplCore::Extension's Application controller. It contains functionality
      # that's usually related to the view.
      
      attr_writer :page_title, :page_description, :page_keywords
      attr_writer :page_copyright, :page_author, :page_generator
      
      # Layout sections can be enabled/disabled using these attributes
      
      attr_accessor :show_sidebar, :show_feedback, :show_inspector, :show_shelf
      
      # Page identifiers for selective css and javascript behaviour
      
      def bodytag_id(prefix = '')
        "#{prefix}#{controller_name.hyphenize}-#{action_name.hyphenize}"
      end

      def bodytag_classname
        "#{slice.name.hyphenize} #{controller_name.hyphenize}"
      end
      
      # Page head/metadata
      
      def info
        @_info ||= core.info.merge(self.slice[:info] || {})
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
      
      # Asset handling
      
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
      
    end
  end
end