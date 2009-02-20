class Range
  def rand
    return first if exclude_end? && last == first
    Kernel::rand(last - first + (exclude_end? ? 0 : 1)) + first
  end
end