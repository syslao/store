class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.role == 'owner'
      can :manage, :all
      cannot [:pro, :buy], Item
    elsif user.role == 'admin'
      can [:read, :pro], Item
      cannot :buy, Item
    else
      can :read, Item
      can :buy, Item
    end
  end
end
