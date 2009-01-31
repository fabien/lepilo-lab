class Hash
  
  def add_html_class(html_class)
    if self[:class]
      self[:class] = "#{self[:class]} #{html_class}"
    else
      self[:class] = html_class.to_s
    end
    self.dup
  end
  
end