# A paying customer for Greentime
class Company < ActiveRecord::Base
  attr_accessible :active, :name

  validates :active, inclusion: { in: [true, false] }
  validates :name, presence: true
  validates :name, length: { maximum: 50 }

  has_many :users, dependent: :restrict
	has_many :tasks, dependent: :restrict
  has_many :clients, dependent: :restrict
  	
  def has_user?(user)
  	self.users.include?(user)
  end

  # Gets the list of users with pending input for the last four weeks
  def users_with_pending_days

    users_with_pending_days = []

    company.users.each do |user|
      users_with_pending_days << user if user.pending_input?
    end

    users_with_pending_days
  end

  # Gets how many hours are pending (total) for users
  # against the total hours in the last four weeks
  def pending_days_percentage
    
  end
end
