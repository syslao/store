class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.role.name == "Padrone"
        can :manage, :all
    else
        can :read, Item
    end
      end
end
