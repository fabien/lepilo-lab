module Merb
  module LocalizationHelper

    def detect_language(*accepted)
      accepted_langs = accepted.flatten.map { |l| l.to_s.downcase.gsub('-','_') }
      accept_langs = request.accept_language.split(/,/) rescue nil
      return nil unless accept_langs && !accepted_langs.empty?
      # Extract langs and sort by weight
      # Example HTTP_ACCEPT_LANGUAGE: "en-au,en-gb;q=0.8,en;q=0.5,ja;q=0.3"
      wl = {}
      accept_langs.each do |accept_lang|
        if (accept_lang + ';q=1') =~ /^(.+?);q=([^;]+).*/
          wl[($2.to_f rescue -1.0)] = $1
        end
      end
      sorted_langs = wl.sort{ |a,b| b[0] <=> a[0] }.map{ |a| a[1] }
      # Look for an exact match
      sorted_langs.each { |l| return l.to_sym if valid_language?(l, accepted_langs) }
      # Look for a similar match
      ret = nil
      sorted_langs.each { |l| ret ||= similar_language?(l, accepted_langs) }
      ret ? ret.to_sym : ret
    end

    private

    def valid_language?(lang, accepted_langs)
      accepted_langs.include?(lang.to_s.downcase) rescue false
    end

    def similar_language?(lang, accepted_langs) 
      return nil if lang.nil?
      return lang.to_sym if valid_language?(lang, accepted_langs)
      # Check lowercase without dashes - returns :nl_nl for example
      lang = lang.to_s.downcase.gsub('-','_')
      return lang.to_sym if accepted_langs.include?(lang)
      # Check without dialect
      if lang.to_s =~ /^([a-z]+?)[^a-z].*/
        lang = $1
        return lang.to_sym if accepted_langs.include?(lang)
      end
      # Check other dialects
      lang_regexp = /^#{lang}_/
      accepted_langs.each { |l| return lang.to_sym if l.match(lang_regexp) }
      # Nothing found
      nil
    end
    
  end
end