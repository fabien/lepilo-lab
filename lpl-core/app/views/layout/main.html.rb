module Views
  module LplCore
    module Layout
      class Main < Views::LplCore::Layout::Base
 
        def render_header
          core.extensions.each do |ext|
            next unless ext.icon?
            builder.div(:class => 'icon') { |button| button.img(:src => ext.icon, :alt => ext.name, :title => ext.name) }
          end
             
          builder.a('sidebar',    :id => 'toggle_sidebar',    :href => '#')
          builder.a('shelf',      :id => 'toggle_shelf',      :href => '#')
          builder.a('inspector',  :id => 'toggle_inspector',  :href => '#')
    
          builder.div(:class => 'lpl_right') do |right|
            right.div(:class => 'lpl_btn_square red', :onclick => "window.location = '/lepilo/auth/logout'") do |button|
              button.text!('Log out')
              button.span ''
            end
          end
        end
  
        def render_shelf
          images = []
          images << core.stylesheet_path('assets/thumbnail-01.png')
          images << core.stylesheet_path('assets/lpl/icons/128x128_file.png')
          
          icons = ['/slices/lpl-core/stylesheets/assets/lpl/icons/40x40_articles.png']
          
          builder.div(:class => 'border') { |border| border.div('', :class => 'handle hor') }
          
          builder.div(:class => 'header') do |header|
            icons.each do |icon|
              header.div(:class => 'icon') { |button|  button.img(:src => icon, :alt => 'icon', :title => 'icon') }
            end
            
            header.input(:id => 'shelf_search', :name => 'shelf_search', :class => 'search', :type => 'text')
            header.div(:id => 'shelf-ajax-search-indicator', :class => 'loading') do |div|
              div.img(:src => core.stylesheet_path('assets/lpl/loading-small-bright.gif'), :alt => 'loading indicator', :title => 'loading')
            end
          end
          
          builder.div(:class => 'scroller') do |scroller|
            scroller.div(:class => 'content') do |content|
              images.each do |img|
                content.div(:class => 'icon-container') do |container|
                  container.img(:src => img, :alt => 'icon')
                  container.text!('stuff blah.jpg')
                  container.div('1200 x 817, PNG', :class => 'metadata')
                end
              end      
            end
          end
        end
        
      end
    end
  end
end