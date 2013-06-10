class User < ActiveRecord::Base
  attr_accessible :email, :facebook_access_token, :facebook_id, :location, :name, :password, :password_confirmation

  has_secure_password

  validates :email, uniqueness: { case_sensitive: false }, presence: true

  has_many :friends, dependent: :destroy

end
