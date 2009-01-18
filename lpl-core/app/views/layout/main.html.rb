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
            right.div(:class => 'lpl_btn_square red', :onclick => "window.location = '/logout'") do |button|
              button.text!('Log out')
              button.span ''
            end
          end
        end
  
        def render_shelf
          images = []
          images << '/slices/lpl-core/stylesheets/assets/thumbnail-01.png'
          images << '/slices/lpl-core/stylesheets/assets/lpl/icons/128x128_file.png'
   
          builder.div(:class => 'border') { |border| border.div(:class => 'handle hor') }
          builder.div(:class => 'content') do |content|
      
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