class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.sysadmin?
      can :manage, :all
    elsif user.admin?
      can :manage, Form, organisation_id: user.organisation.id
      can :manage, Report, form: { organisation_id: user.organisation.id }
      can :manage, ReportFile
    elsif user.editor?
      can :manage, User, id: user.id
    elsif user.user?
      can :manage, User, id: user.id
      can :show, Form, organisation_id: user.organisation.id
      can :manage, Report, form: { organisation_id: user.organisation.id }
      can :manage, ReportFile
    end
  end
end

