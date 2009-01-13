module Merb
  module Slices
    module ModuleMixin

      def inherit_structure_from_slice(other)
        # This is different from normal slices - we want the current slice's paths
        # to take precedence over the other's paths. The core slice's behaviour
        # can be overridden by the current slice, including views.
  
        self.push_app_path(:root, root_path, nil)
        self.push_path(:root, other.dir_for(:root), nil)
  
        self.push_app_path(:application, app_dir_for(:root) / 'app', nil)
        self.push_path(:application, other.dir_for(:root) / 'app', nil)
  
        app_components.each do |component|
          self.push_app_path(component, app_dir_for(:application) / "#{component}s")
          self.push_path(component, other.dir_for(:application) / "#{component}s")
        end
  
        # first look at Merb.root / 'public' / 'slices' / 'slice-name' then inside slice itself
        self.push_app_path(:public, Merb.dir_for(:public) / 'slices' / self.identifier, nil)
        self.push_path(:public, root_path('public'), nil)
  
        public_components.each do |component|
          self.push_app_path(component, app_dir_for(:public) / "#{component}s", nil)
          self.push_path(component, dir_for(:public) / "#{component}s", nil)
        end
      end
      
    end
  end
end