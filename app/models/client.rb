# A client for the company
class Client < ActiveRecord::Base
  belongs_to :company
  validates :company, presence: true
  has_many :projects, dependent: :restrict

  attr_accessible :name

  validates :name, presence: true

  # Returns client visible for an user
  def self.mine(user)
  	return Client.where("company_id = #{user.company.id}").order("name ASC").all if user.manager?
  	self.joins(:projects).joins(projects: :users).where("projects_users.user_id = #{user.id}").order("name ASC").uniq
  end
end
