class Cssmin
  
  # Add this to Merb::BootLoader.after_app_loads:
  #
  # Merb::Assets::StylesheetAssetBundler.add_callback do |filename| 
  #   Cssmin.new(File.read(filename)).write(filename) if File.exists?(filename)
  # end

	def initialize(input)
		@input = input
	end
	
	def output
		compress_css(@input)
	end
	
	def write(filename)
	  File.open(filename, "w") { |f| f.flock(File::LOCK_EX); f.write(self.output); f.flock(File::LOCK_UN) }
  end

	private

	def compress_css(source)
    source.gsub!(/\s+/, " ")           # collapse space
    source.gsub!(/\/\*(.*?)\*\/ /, "") # remove comments - caution, might want to remove this if using css hacks
    source.gsub!(/\} /, "}\n")         # add line breaks
    source.gsub!(/\n$/, "")            # remove last break
    source.gsub!(/ \{ /, " {")         # trim inside brackets
    source.gsub!(/; \}/, "}")          # trim inside brackets
    source
  end

end