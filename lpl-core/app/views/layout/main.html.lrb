module Views
  module LplCore
    module Layout
      class Main < Views::LplCore::Layout::Base
 
        def render_header
          render_header_icons(core.extensions)
          render_toggle_icons(:sidebar, :shelf, :inspector)
        end
        
        def render_feedback
          unless message.empty?
            msg_type = message[:failure] || message[:warning] ? 'fail' : 'yay'   
            builder.div(:id => 'lpl_flash', :class => msg_type) do |feedback|
              feedback.a('close', :href => '#', :title => 'close message', :id => 'close_flash', :class => 'lpl_close')
              feedback.p(message[:success] || message[:failure] || message[:warning] || message[:notice])
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
        
        def render_modal
          builder.div(:id => 'lpl_core_modal_dialog') do |dialog|
            dialog.h1('')
            dialog.div('', :class => 'msg')
            dialog.div('', :class => 'content')
          end         
        end
        
        protected
        
        def render_header_icons(*extensions)
          extensions.flatten.each do |ext|
            next unless ext.icon? # only show extensions that have a designated icon
            builder.a(:href => slice_url(ext.identifier_sym, :index), :class => 'icon') do |button| 
              button.img(:src => ext.icon, :alt => "#{ext.name} (v. #{ext.version})", :title => ext.description)
            end
          end
        end
        
        def render_toggle_icons(*names)
          builder.div(:class => 'icons-toggle') do |toggle|
            names.flatten.each do |icon|
              toggle.a(:id => "toggle_#{icon}", :class => 'icon toggle') do |div|
                div.img(:src => core.stylesheet_path("assets/lpl/icons/48x48_#{icon}.png"), :alt => "toggle #{icon}")
              end              
            end
            toggle.div('', :class => 'icon space')
            toggle.a('logout', :href => slice_url(:merb_auth_slice_password, :logout), :class => 'icon logout')
          end
        end
        
      end
    end
  end
end