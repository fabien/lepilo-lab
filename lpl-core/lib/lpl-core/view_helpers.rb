module LplCore
  module ViewHelpers
  
    # Common UI elements
  
    def square_button(label, attrs = {})
      builder.a(label, attrs.merge(:class => (attrs[:class] ? "lpl_btn_square #{attrs[:class]}" : "lpl_btn_square")))
    end
    
    # Core layout helpers 
    
    def sidebar_title(title)
      builder.h1(title, :class => 'lpl_sidebar')
    end
    
    def sidebar_tree(links, options = {})
      sidebar_list(links, options.merge(:class => 'rounded'))
    end
    
    def sidebar_folders(links, options = {})
      sidebar_list(links, options.merge(:class => 'folder'))
    end
    
    def sidebar_list(links, options = {})
      sidebar_title(options[:title]) if options[:title]
      builder.div(:class => options[:class] ? "lpl_list #{options[:class]}" : "lpl_list") do |div|
        div.ul do |ul|
          links.each { |l| sidebar_list_item(l) }          
        end
      end   
    end
    
    # Main content helpers
    
    def rounded_container(attrs = {}, &block)
      attrs[:class] = (attrs[:class] ? "lpl_container_rounded #{attrs[:class]}" : "lpl_container_rounded")
      builder.div(attrs) do |container|
        yield container if block_given?
      end
    end
    
    def content_list(items, attrs = {}, &block)
      attrs[:class] = (attrs[:class] ? "lpl_content_list #{attrs[:class]}" : "lpl_content_list")
      list_proxy = ContentListProxy.new(self)
      builder.ul(attrs) do |list|
        items.each_with_index do |item, idx|
          item_id = item[:id] rescue idx.to_s
          list_attrs = {}
          list_attrs[:id] = [attrs[:id] || 'list', item_id].join('-')    
          list.li(list_attrs) do |li|
            yield(list_proxy, item)
          end          
        end
      end
    end
    
    def pagination(status, prev_link = '#prev', next_link = '#next', attrs = {})
      attrs[:class] = (attrs[:class] ? "pagination #{attrs[:class]}" : "pagination")
      builder.div(attrs) do |pag|
        pag.div(status, :class => 'page')
        pag.div(:class => 'lpl_canal_32', :style => 'width:44px') { |d| d.span('') }
        pag.a('previous', :href => prev_link, :class => 'lpl_previous_round_24') if prev_link
        pag.a('next',     :href => next_link, :class => 'lpl_next_round_24')     if next_link
      end
    end
    
    protected
    
    def sidebar_list_item(link)
      label = link[:label] || ''
      description = link[:description] || label
      li_attrs = link[:active] ? { :class => 'active' } : {}          
      # add the link to the opened <ul>
      if link[:url].blank?
        builder.li(label, li_attrs.merge(:title => description))
      else
        builder.li(li_attrs) do |li|
          li.a(label, :href => link[:url], :title => description)
        end
      end         
      # recurse further downwards inside the current <li>
      unless (links = link[:links]).blank?
        builder.li(:class => 'container') do |li|
          li.ul do |ul|
            links.each { |l| sidebar_list_item(l) }
          end
        end
      end
    end
    
    # View helper classes
    
    class ContentListProxy
      
      # This class represents the content list; it's being yielded alongside
      # each content item, which then uses this proxy to append markup.
      
      attr_reader :view
      
      def initialize(view)
        @view = view
      end
      
      # You will have to call the methods in the following order.
      
      def reorder
        builder.div(:class => 'reorder') do |d|
          d.a('move', :href => '#', :class => 'lpl_action_20 reorder side', :title => 'reorder item')
        end
      end
      
      def actions(&block)
        builder.div(:class => 'actions') do |edit|
          yield self
        end
      end
      
      def action(name, attrs = {})
        # name is one of: preview, edit, recycle or delete
        attrs[:class] = (attrs[:class] ? "lpl_action_20 #{name} #{attrs[:class]}" : "lpl_action_20 #{name}")
        builder.a(name.to_s, attrs)
      end
      
      def title(string, link_attrs = {})
        if link_attrs.empty?
          builder.h2(string)
        else
          builder.h2 do |h2|
            h2.a(string, link_attrs)
          end
        end
      end
      
      def thumbnail(src, attrs = {})
        builder.div(:class => 'thumbnail') do |tn|
          tn.img(attrs.merge(:src => src))
        end          
      end
      alias :icon :thumbnail
      
      def metadata(*stings)
        mdata = stings.flatten.reject { |s| s.blank? }
        builder.div(mdata.join(' | '), :class => 'metadata') unless mdata.empty?
      end
      
      def description(string)
        builder.div(string, :class => 'description')
      end
      
      # Helper method.
      
      def builder
        view.builder
      end
      
      def <<(string_or_view)
        view << string_or_view
      end
      
    end
    
    class LplLink
      
      # This class can be used instead of a plain Hash; it's also the interface
      # implementation of link-compatible objects. See #sidebar_list_item.
      #
      # Example usage:
      #
      # links = []
      # 
      # links << LplLink.new(:label => 'One', :url => '/one') do |link|
      #   link << LplLink.new(:label => 'Nested One A', :url => '/one/nested/a', :active => true)
      #   link << LplLink.new(:label => 'Nested One B', :url => '/one/nested/b')
      # end
      # 
      # links << LplLink.new(:label => 'Two', :url => '/two', :active => true) do |link|
      #   link << LplLink.new(:label => 'Nested Two A', :url => '/two/nested/a')
      #   link << LplLink.new(:label => 'Nested Two B', :url => '/two/nested/b') do |nested|
      #     nested << LplLink.new(:label => 'Nested Nested Two A', :url => '/two/nested/nested/a')
      #   end
      # end
      
      # These are the attributes (as Hash/bracket keys) any Linkable object should provide;
      # they will be accessed through the bracket accessors below.
      
      attr_accessor :label, :url, :description, :active
      
      def initialize(hsh = {}, &block)
        [:label, :url, :description, :active].each do |key|
          self[key] = hsh[key]
        end
        yield self if  block_given?
      end
      
      # These are the methods any Linkable object should provide.
      
      def [](key)
        send(:"#{key}") if self.respond_to?(:"#{key}")
      end
      
      def []=(key, value)
        send(:"#{key}=", value) if self.respond_to?(:"#{key}=")
      end
      
      def links
        @links ||= []
      end
      
      # Convenience method.
      
      def <<(link)
        links << (link.is_a?(self.class) ? link : self.new(link))
      end
      
    end
    
  end
end

