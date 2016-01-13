class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.has_role? :sysadmin
      can :manage, :all
    else
      can :show, User
    end
  end
end
