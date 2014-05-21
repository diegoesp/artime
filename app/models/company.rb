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
    self.internal_projects
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

  # Returns the internal projects for the company. If no internal projects can
  # be found, one is created
  def internal_projects
    internal_projects = Project.joins(:client).where("company_id = #{self.id} AND internal = true")
    return internal_projects if internal_projects.length > 0
  
    internal_project = Project.new(name: "#{self.name} (Internal)", internal: true, deadline: Date.today, description: "Holds tasks that are accessed by all users")
    internal_project.client = internal_client
    internal_project.save!

    [internal_project]
  end

  # Gets the client used as internal
  def internal_client
    clients = Client.where(name: "#{self.name} Internal")
    return clients.first if clients.length > 0

    client = Client.new(name: self.name)
    client.company = self
    client.save!
    client
  end

end
