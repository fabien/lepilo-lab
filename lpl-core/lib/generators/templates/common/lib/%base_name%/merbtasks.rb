namespace :lpl_extensions do
  namespace :<%= symbol_name %> do
  
    desc "Install <%= module_name %>"
    task :install => [:preflight, :setup_directories, :copy_assets, :migrate]
    
    desc "Test for any dependencies"
    task :preflight do # see slicetasks.rb
    end
  
    desc "Setup directories"
    task :setup_directories do
      puts "Creating directories for host application"
      <%= module_name %>.mirrored_components.each do |type|
        if File.directory?(<%= module_name %>.dir_for(type))
          if !File.directory?(dst_path = <%= module_name %>.app_dir_for(type))
            relative_path = dst_path.relative_path_from(Merb.root)
            puts "- creating directory :#{type} #{File.basename(Merb.root) / relative_path}"
            mkdir_p(dst_path)
          end
        end
      end
    end
  
    desc "Copy public assets to host application"
    task :copy_assets do
      puts "Copying assets for <%= module_name %> - resolves any collisions"
      copied, preserved = <%= module_name %>.mirror_public!
      puts "- no files to copy" if copied.empty? && preserved.empty?
      copied.each { |f| puts "- copied #{f}" }
      preserved.each { |f| puts "! preserved override as #{f}" }
    end
    
    desc "Migrate the database"
    task :migrate do # see slicetasks.rb
    end
    
  end
end