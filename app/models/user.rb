class User < ActiveRecord::Base
  rolify

  after_create :default_role

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  private

  def default_role
    add_role :normal_user
  end
end
