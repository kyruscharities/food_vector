class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new # for guest

    # call the method for each role to set permissions
    # (this allows for inherited roles)
    everyone
    @user.roles.each { |role| send(role.name) }
  end

  def everyone
    can :manage, FoodSource
    can :manage, GeographicDataPoint
  end

  def admin
    can :manage, :all
  end

  def normal_user
    can [:create, :index], Analysis
    can :manage, Analysis, :user_id => @user.id
  end
end
