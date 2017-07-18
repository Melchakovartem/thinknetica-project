class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Vote]
    can :update, [Question, Answer], user_id: user.id
    can :destroy, [Question, Answer, Vote], user_id: user.id
    can :select, Question, user_id: user.id
  end
end
