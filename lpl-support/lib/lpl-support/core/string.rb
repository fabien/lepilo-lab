require 'iconv'
require 'cgi'
require 'base64'
require 'digest/md5'

class String #:nodoc:
  
  EXT_REGEX = /([^\/]+)\.([a-z_^\/]+)$/i
  TO_NUMERIC_SEPERATOR = :comma
  
  INT_CHARS_LOWER = 'àáâãäåæçèéêëìíîïñòóôõöøœùúûüÿ'
  INT_CHARS_UPPER = 'ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÑÒÓÔÕÖØŒÙÚÛÜŸ'
  
  # taken from: http://www.w3.org/International/questions/qa-forms-utf-8
  UTF8REGEX = /\A(?:                               # ?: non-capturing group (grouping with no back references)
                [\x09\x0A\x0D\x20-\x7E]            # ASCII
              | [\xC2-\xDF][\x80-\xBF]             # non-overlong 2-byte
              |  \xE0[\xA0-\xBF][\x80-\xBF]        # excluding overlongs
              | [\xE1-\xEC\xEE\xEF][\x80-\xBF]{2}  # straight 3-byte
              |  \xED[\x80-\x9F][\x80-\xBF]        # excluding surrogates
              |  \xF0[\x90-\xBF][\x80-\xBF]{2}     # planes 1-3
              | [\xF1-\xF3][\x80-\xBF]{3}          # planes 4-15
              |  \xF4[\x80-\x8F][\x80-\xBF]{2}     # plane 16
              )*\z/mnx
  
  def to_filename_and_extension
    file_name = File.basename(self)
    mres = EXT_REGEX.match(file_name)
    mres.nil? ? [file_name, ''] : [mres[1], mres[2]]
  end
  
  def to_numeric(decimal_seperator = TO_NUMERIC_SEPERATOR)
    num = (self.match(/([\,\.0-9]+)/) || [''])[0]
    num.gsub!(/\,(\d+)/, '.\1') if (decimal_seperator == :comma && num =~ /\,(\d+)/)
    num =~ /\.(\d+)/ ? num.to_f : num.to_i
  end
  
  def integer?
    !(self =~ /^\d+$/).nil?
  end

  def to_range
    if matches = self.match(/^([^-]+)-([^-]+)$/)
      Range.new(*matches.captures)
    else  
      Range.new
    end
  end
  
  def to_range_or_array
    if self.index(',')
      self.split(',').map { |s| s.strip }
    else
      to_range
    end
  end
  
  def qp_encode
    [self].pack("M").gsub(/\n/, "\r\n")
  end
  
  def qp_decode
    self.gsub(/\r\n/, "\n").unpack("M").first
  end
  
  def base64encode
    Base64.encode64(self)
  end
    
  def base64decode
    Base64.decode64(self)
  end
  
  def md5hexdigest
    Digest::MD5.hexdigest(self)
  end
  
  def utf8?
    self =~ UTF8REGEX
  end
  
  def hex_encode
    self.unpack('H*').to_s
  end
  
  def hex_decode
    [self].pack('H*')
  end
  
  def iso2utf8
    Iconv::conv('utf-8', 'iso-8859-1', self)
  end
    
  def utf82iso
    Iconv::conv('iso-8859-1', 'utf-8', self)
  end  
    
  def xmlencode
    self.unpack('c*').map{ |c|"&\##{c};" }.join
  end
  
  def urlencode
    self.split('').map{ |c| "%#{c.unpack('H2')}" }.join
  end
  
  def urlescape
    CGI.escape(self).gsub('+', '%20')
  end
  
  alias :original_upcase :upcase
    
  def upcase
    self.original_upcase.tr(INT_CHARS_LOWER, INT_CHARS_UPPER)
  end
  
  alias :original_downcase :downcase
  
  def downcase
    self.original_downcase.tr(INT_CHARS_UPPER, INT_CHARS_LOWER)
  end
  
  # Flickr style splitting of a string: tag1 tag2 "tag 3 has spaces" tag4
  def split_as_tags
    split(/"(.+?)"|\s+/).reject { |s| s.empty? }
  end
  
  def translit
    self.gsub(/[^\x20-\x7f]/){ Iconv.iconv('us-ascii//IGNORE//TRANSLIT', 'utf-8',$&)[0].sub(/^[\^`'"~](?=[a-z])/i, '') }
  end
  alias :to_ascii :translit
  
  def translit!
    replace translit
  end
  alias :to_ascii! :translit!
  
  def title_case
    Extlib::Inflection.humanize(Extlib::Inflection.underscore(self)).gsub(/\b('?[a-z])/) { $1.capitalize }
  end
  
  # sanitize string for url or filename usage
  def urlify(delimiter = '-', allow = '', cut = 0)
    str = self.translit.downcase.strip
    return str if str.empty?
    esc_delim = Regexp.escape(delimiter)
    esc_allow = Regexp.escape(allow)
    str = str.word_truncate(cut, '') unless cut == 0
    str.gsub!(/[^a-z0-9#{esc_allow}#{esc_delim}]/, ' ')
    str.gsub!(/^([\s#{esc_allow}#{esc_delim}]+)/, '')
    str.gsub!(/([\s#{esc_allow}#{esc_delim}]+)$/, '')
    str = str.title_case if delimiter.blank?
    str.gsub!(/\s+/, delimiter)
    str.gsub!(/#{esc_delim}{2,}/, delimiter) unless delimiter.blank?
    return str.strip
  end
  
  def urlify!
    replace urlify
  end
  
  def rubify
    downcase.gsub(/\W/, ' ').strip.gsub(/(\s|-)+/, '_')
  end

  def rubify!
    replace rubify
  end
  
  def word_truncate(length = 32, etc = '...')
    return '' if length == 0
    return self if self.length <= length
    fragment = self.slice(0, length)
    fragment.gsub!(/\s+(\S+)?$/, '')
    fragment.gsub!(/[,\.-_?!]$/, '')
    fragment.strip!
    return fragment << etc   
  end
  
  def word_truncate!(length = 32, etc = '...')
    replace word_truncate
  end
  
  def word_truncate_middle(length = 32, etc = '.....', words = true, mid_weighed = true)
    return '' if length == 0
    return self if self.length <= length
    p_length = ((length - etc.length) / 2).floor
    s_length = mid_weighed ? 0 : (p_length / 2).floor
    
    fragment_left = self.slice(0, p_length + s_length)
    fragment_left = words ? fragment_left.gsub(/\s+(\S+)?$/, '') : fragment_left.slice(0, -1)
    fragment_left = '' if fragment_left.nil?
    fragment_left.gsub!(/[,\.-_?!]$/, '')
    
    fragment_right = self.slice(-(p_length - s_length), p_length - s_length)
    fragment_right = words ? fragment_right.gsub(/\s+$/, '') : fragment_right.slice(0, 1) 
    fragment_right = '' if fragment_right.nil?
    fragment_right.gsub!(/^[,\.-_?!]/, '')
    
    return fragment_left.strip << etc << fragment_right.strip
  end
  
  def word_truncate_middle!(length = 32, etc = '.....', words = true, mid_weighed = true)
    replace word_truncate_middle
  end
  
end