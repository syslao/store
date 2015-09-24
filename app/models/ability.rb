class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.role.name == "Owner"
        can :manage, :all
        cannot :pro, Item
    elsif user.role.name == "Admin"
        can [:read, :pro ], Item
    else
        can :read, Item
    end
   end
end
