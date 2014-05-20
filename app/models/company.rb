# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  active     :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  plan_id    :integer
#

# A paying customer for the SASS
class Company < ActiveRecord::Base
  attr_accessible :active, :name, :plan, :plan_id

  validates :active, inclusion: { in: [true, false] }
  validates :name, presence: true
  validates :name, length: { maximum: 50 }
  validates :name, uniqueness: true

  belongs_to :plan

  has_many :users, dependent: :restrict
	has_many :tasks, dependent: :restrict
  has_many :clients, dependent: :restrict
  
  after_save :after_save

  def after_save
    self.internal_project
  end

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

  # Returns the internal project for the company. If it does not exists,
  # it creates it
  def internal_project
    internal_client = self.clients.where("name = 'INTERNAL'").first
    if internal_client.nil? then
      internal_client = Client.new(name: "INTERNAL", active: false)
      internal_client.company = self
      internal_client.save!
    end
    internal_project = internal_client.projects.where("name = 'INTERNAL'").first
    if internal_project.nil? then
      internal_project = Project.new(deadline: Date.today, name: "INTERNAL", active: false, description: "Holds global tasks")
      internal_project.client = internal_client
      internal_project.save!
    end
    internal_project
  end

end
