class User < Practice
  authenticates_with_sorcery!
  attr_accessible :email, :password, :password_confirmation
end

