class Ability
  include CanCan::Ability

  # Define abilities for the passed in user here. For example:
  #
  #   user ||= User.new # guest user (not logged in)
  #   if user.admin?
  #     can :manage, :all
  #   else
  #     can :read, :all
  #   end
  #
  # The first argument to `can` is the action you are giving the user permission to do.
  # If you pass :manage it will apply to every action. Other common actions here are
  # :read, :create, :update and :destroy.
  #
  # The second argument is the resource the user can perform the action on. If you pass
  # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
  #
  # The third argument is an optional hash of conditions to further filter the objects.
  # For example, here the user can only update published articles.
  #
  #   can :update, Article, :published => true
  #
  # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.has_role? :admin
      can :manage, [Article, Beer, Brewery, Comment, Forum, Post, Review, Role, User]
    end

    if user.has_role? :treasurer
      can :manage, Payment
    end

    can :read, [User, Article, Comment, Post, Payment]
    can [:show, :edit, :update], User, :id => user.id
    if user.confirmed_at.nil? == false
      can :create, Comment
      can [:edit, :update, :destroy], Comment, :user_id => user.id
      can :create, Post
      can [:edit, :update, :destroy], Post, :user_id => user.id
    end
  end
end
