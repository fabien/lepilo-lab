module Merb::Generators
  
  class LplExtensionGenerator < Generator
    
    option :thin, :as => :boolean, :desc => 'Generates a thin lpl_extension'
    option :very_thin, :as => :boolean, :desc => 'Generates an even thinner lpl_extension'
    
    desc <<-DESC
      Generates a lpl_extension for Lepilo.
    DESC

    def initialize(*args)
      Merb.disable(:initfile)
      super
    end
    
    first_argument :name, :required => true
    
    invoke :core_lpl_extension, :thin => nil, :very_thin => nil
    # invoke :thin_lpl_extension, :thin => true
    # invoke :very_thin_lpl_extension, :very_thin => true
    
  end
  
  class BaseLplExtensionGenerator < NamedGenerator
    
    def self.common_template(name, template_source)
      common_base_dir = File.expand_path(File.dirname(__FILE__))
      template name do |t|
        t.source = File.join(common_base_dir, 'templates', 'common', template_source)
        t.destination = template_source
      end
    end
    
    def self.common_directory(name, source_dir)
      common_base_dir = File.expand_path(File.dirname(__FILE__))
      directory name do |d|
        d.source = File.join(common_base_dir, 'templates', 'common', source_dir)
        d.destination = source_dir
      end
    end
    
  end
  
  add :lpl_extension, LplExtensionGenerator
  
end
