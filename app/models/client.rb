# == Schema Information
#
# Table name: clients
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  company_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  active     :boolean          default(TRUE), not null
#

# A client for the company
class Client < ActiveRecord::Base
  belongs_to :company
  has_many :projects, dependent: :restrict

  attr_accessible :name, :active

  validates :active, inclusion: { in: [true, false] }
  validates :name, presence: true
  validates :company, presence: true

  # Returns client visible for an user
  def self.mine(user)
  	return Client.where("company_id = #{user.company.id} AND clients.active = true").order("name ASC").all if user.manager?
  	self.joins(:projects).joins(projects: :users).where("projects_users.user_id = #{user.id} AND clients.active = true").order("name ASC").uniq
  end
end
