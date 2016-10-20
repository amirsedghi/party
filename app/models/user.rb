class User < ActiveRecord::Base
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i

  has_secure_password
  has_many :events, dependent: :destroy
  has_many :attendees, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :event_attends, through: :attendees, source: :event
  validates :state, :city, presence: true
  validates :first_name, :last_name, presence: true, length: { in: 2..20 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: EMAIL_REGEX }
  validates :password, presence: true, length: { in: 8..20 }, :on => :create

end
