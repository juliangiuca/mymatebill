class Object
  def try_harder(method)
    if self.try(method).present?
      self.try(method)
    end
  end
end
