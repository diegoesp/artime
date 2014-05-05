# A paying customer for the SASS
class Company < ActiveRecord::Base
  attr_accessible :active, :name, :plan, :plan_id

  validates :active, inclusion: { in: [true, false] }
  validates :name, presence: true
  validates :name, length: { maximum: 50 }

  belongs_to :plan

  has_many :users, dependent: :restrict
	has_many :tasks, dependent: :restrict
  has_many :clients, dependent: :restrict
  	
  def has_user?(user)
  	self.users.include?(user)
  end

  # Gets the list of users with pending input for the last four weeks
  def users_with_pending_input
    users_with_pending_days = []
    self.users.each do |user|
      users_with_pending_days << user if user.pending_input?
    end
    users_with_pending_days
  end

  # Gets how many hours were completed by users
  # against the total hours in the last four weeks
  def input_completed_percentage
    total_input_days = 0
    total_pending_input = 0
    self.users.each do |user|
      pending_input, input_days = user.pending_input
      total_pending_input += pending_input
      total_input_days += input_days
    end
    # If no users, then input is OK
    return 1 if total_input_days == 0
    ((total_input_days - total_pending_input) / total_input_days.to_f).round(2)
  end
end