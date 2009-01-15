class String
  
  def hyphenize
    to_const_path.tr('/_', '-')
  end
  
end