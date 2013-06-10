class Friend < ActiveRecord::Base
  attr_accessible :facebook_id, :location, :name, :user_id

  # Associations
  belongs_to :user

  # Validations
  validates :user, presence: true
  validates :location, presence: true
  validates :facebook_id, uniqueness: { scope: :user_id }

  # Callbacks

end
