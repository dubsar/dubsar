class User < System
  authenticates_with_sorcery!
  has_many :capabilities
  has_many :roles, :through => :capabilities
  attr_accessible :email, :password, :password_confirmation, :roles

  def is?(_role)
    roles.any? { |r| r.name.underscore.to_sym == _role }
  end

end

