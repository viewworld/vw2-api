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
      can :show, Organisation, id: user.organisation.id
    elsif user.editor?
      can :manage, User, id: user.id
    elsif user.user?
      can :manage, User, id: user.id
      can :read, Form, { organisation_id: user.organisation.id, active: true }
      can :manage, Report, form: { organisation_id: user.organisation.id }
      can :manage, ReportFile
      can :show, Organisation, id: user.organisation.id
    end
  end
end

