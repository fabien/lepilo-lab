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
  
end