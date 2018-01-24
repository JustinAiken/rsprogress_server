class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user
    can :manage, :all if user.admin?

    can :manage, GameProgress,        user_id: user.id
    can :manage, ArrangementProgress, user_id: user.id
    can :manage, PersonalFlag,        user_id: user.id
    can :manage, ArrangementNote,     user_id: user.id
  end
end
