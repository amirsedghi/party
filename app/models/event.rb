class Event < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :attendees, dependent: :destroy
  has_many :users, through: :attendees
  validates :name, :date, :city, :state, presence: true
  validates :date, inclusion: { in: (Date.today..Date.today+5.years) }
end
