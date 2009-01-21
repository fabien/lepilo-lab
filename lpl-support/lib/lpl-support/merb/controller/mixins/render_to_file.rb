module Merb
  module RenderToFileMixin
  
    private

    # Render a preset
    def render_preset(preset, *args, &block)
      raise NotFound unless content_type && preset_exists?(preset)
      send(:"#{preset.to_s.rubify}_preset", *args, &block)
    end

    # Figure out if a preset handler exists
    def preset_exists?(preset)
      self.respond_to?(:"#{preset.to_s.rubify}_preset")
    end
    
    # Stores the given file (responding to save) at the current request path
    def save_file(file)
      FileUtils.mkdir_p(File.dirname(full_request_path))
      file.save(full_request_path)
    end
  
    # The absolute path derived from the request where files will be stored
    #
    # Defaults to public/<controller_name>
    def base_request_path
      Merb.dir_for(:public) / controller_name.underscore
    end
    
    # The absolute path for the request - the file location
    def full_request_path
      File.expand_path(Merb.dir_for(:public) / request.path)
    end

    # The absolute path to the directory of the requested preset
    def preset_request_path
      raise NotFound unless params.key?(:preset)
      File.expand_path(base_request_path / params[:preset])
    end

    # Force-clean any empty directories within the given path (excluding itself)
    def cleanup_empty_dirs!(path)
      if File.directory?(path) && path.index(Merb.root) == 0
        system("find #{path} -depth -empty -type d -exec rmdir {} \\;")
      end
    end

    # Return the mime-type for the current request format
    def content_type_for(key)
      raise ArgumentError, ":#{key} is not a valid MIME-type" unless Merb::ResponderMixin::TYPES.key?(key.to_sym)
      Array(Merb::ResponderMixin::TYPES[key.to_sym][:accepts]).first
    end
   
  end
end