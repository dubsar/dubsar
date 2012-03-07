class Email < Thing
  has_many :emailables, :foreign_key => 'thing_id'
  def to_s
    email
  end
  def self.create(attributes = nil, options = {}, &block)
    binding.pry
    create!(attributes, options, &block)
  end
end

