class Numeric

  STORAGE_UNITS = %w( Bytes KB MB GB TB ).freeze
  
  def human_size(options = {})
    precision ||= (options[:precision] || 2)
    separator ||= (options[:separator] || '.')

    max_exp  = STORAGE_UNITS.size - 1
    number   = Float(self)
    exponent = (Math.log(number) / Math.log(1024)).to_i # Convert to base 1024
    exponent = max_exp if exponent > max_exp # we need this to avoid overflow for the highest unit
    number  /= 1024 ** exponent
    unit     = STORAGE_UNITS[exponent]

    begin
      return "1 Byte" if number == 1 && unit == 'Bytes'
      escaped_separator = Regexp.escape(separator)
      ("%#{separator}#{precision}f" % number).sub(/(\d)(#{escaped_separator}[1-9]*)?0+\z/, '\1\2').sub(/#{escaped_separator}\z/, '') + " #{unit}"
    rescue
      number
    end
  end
  
end