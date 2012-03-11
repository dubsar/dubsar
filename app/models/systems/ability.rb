class Ability
  include CanCan::Ability
  def initialize(_user)
    _user ? user_rules(_user) : guest_user_rules
  end
  def user_rules(_user)
    _user.roles.each do |role|
      exec_role_rules(role) if _user.roles.include? role
    end
    default_rules
  end
  def exec_role_rules role
    meth = :"#{role}_rules"
    send(meth) if respond_to? meth
  end
  def admin_rules
    can :edit, Intitution
    can :manage, :all
  end
  def default_rules
    can :read, :all
  end
  def guest_user_rules
    can :read, :all
  end
end

