class Video < Medium
  self.abstract_class = true
  def src
    # abstract
    # must be implemented by subclasses
    # as the url pointing to the resource
  end
end
