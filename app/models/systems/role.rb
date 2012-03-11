class Role < System
  has_many :capabilities
  has_many :users, :through => :capabilities
end

