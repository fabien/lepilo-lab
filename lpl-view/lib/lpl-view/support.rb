module Builder
  class XmlMarkup

    # Make the internal attributes public, so we can operate on them.
    attr_accessor :target, :indent, :level, :encoding

  end  
end