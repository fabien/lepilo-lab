gem 'mime-types'
require 'mime/types'

module MIME  
  class Type
    
    def description(locale = :en)
      MIME::Types.descriptions[content_type][locale.to_sym]
    end
    
  end
  
  class Types
    
    DESCRIPTION_MIME_MATCH  = /^([^\s\/]+)\/([^\s\/]+)\n/
    DESCRIPTION_DESCR_MATCH = /^\tdescription=(.*)/
    DESCRIPTION_LOCAL_MATCH = /^\t\[([a-z]+)\]description=(.*)/
        
    def self.descriptions
      @descriptions ||= begin
        hsh, mimetype = {}, nil
        File.read(File.dirname(__FILE__) / 'mimetype-descriptions.txt').each_line do |line|
          if matches = line.match(DESCRIPTION_MIME_MATCH)
            mimetype = matches.captures[0] + '/' + matches.captures[1]
            hsh[mimetype] ||= {}
          elsif matches = line.match(DESCRIPTION_DESCR_MATCH)
            hsh[mimetype].default = matches.captures[0]
          elsif matches = line.match(DESCRIPTION_LOCAL_MATCH)
            next unless LplSupport.mimetype_locales.include?(matches.captures[0])
            hsh[mimetype][matches.captures[0].to_sym] = matches.captures[1]
          end
        end
        hsh
      end
    end
   
  end
  
end