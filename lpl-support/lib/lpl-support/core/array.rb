class Array
  
  module PaginationMethods
    attr_accessor :total, :page, :pages, :per_page, :offset
    attr_accessor :prev_url, :next_url
    
    def prev_page
      self.page - 1
    end
    
    def prev_page?
      self.page > 1
    end
    
    def next_page
      self.page + 1
    end
    
    def next_page?
      self.page < self.pages
    end
    
  end
  
  def paginate(page = 1, per_page = 5)
    self.meta_class.send(:include, PaginationMethods) unless self.include?(PaginationMethods)
    self.total    = self.length
    self.per_page = per_page.to_i
    self.page     = page.to_i
    self.pages    = (self.total / self.per_page.to_f).ceil
    self.offset   = self.per_page * (self.page - 1)
    if self.offset >= self.total
      self.offset = self.total - (self.total % self.per_page)
    elsif self.offset < 0
      self.offset = 0
    end
    self.slice(self.offset, self.per_page)
  end
  
  def paginate!(page = 1, per_page = 5)
    self.replace(paginate(page, per_page))
  end
  
  # top-to-bottom then left-to-right row-column behaviour
  def chunk(pieces = 2)
    len = self.length; mid = (len / pieces); chunks = []; start = 0 
    1.upto(pieces) do |i| 
      last = start + mid 
      last = last - 1 unless len % pieces >= i 
      chunks << self[start..last] || [] 
      start = last + 1 
    end 
    chunks 
  end
  
  # left-to-right then top-to-bottom column-row behaviour
  def chunk_columns(number_of_chunks = 2)
    chunks = Array.new(number_of_chunks) { [] }
    count = 0
    self.each do |e|
      chunks[count] << e 
      count = (count < number_of_chunks-1) ? count + 1 : 0
    end
    chunks
  end

  def chunk_into(max_size_of_array = 5)
    chunks = [[]]
    self.each do |e|
      chunks << [] unless chunks.last.length < max_size_of_array
      chunks.last << e
    end
    chunks
  end
  
  def swap!(a, b)
    self[a], self[b] = self[b], self[a]
    self
  end
  
  def flatten_deeper
    self.collect { |element| element.respond_to?(:flatten) ? element.flatten : element }.flatten
  end
  
  def shuffle
    self.sort_by{ rand }
  end
  
  def randomly_pick(number = 1)
    self.shuffle.slice(0...number)
  end
  
  def randomly_pick_one
    self.randomly_pick.first
  end
  
end