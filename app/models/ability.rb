# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    user ? user_abilities : guest_abilities
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :edit, [Question, Answer], user_id: user.id
    can :update, [Question, Answer, Comment], user_id: user.id
    can :destroy, [Question, Answer], user_id: user.id

    can :destroy, ActiveStorage::Attachment do |resource|
      user.author?(resource.record)
    end

    can :destroy, Link do |resource|
      user.author?(resource.parent)
    end

    can :best, Answer do |resource|
      user.author?(resource.question)
    end

    can [:upvote, :downvote], [Question, Answer]
    cannot [:upvote, :downvote], [Question, Answer], user_id: user.id
    can :unvote, [Question, Answer]
  end
end
