# == Schema Information
#
# Table name: administrations
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# An administration that pays to bring the service to tenants
class Administration < ActiveRecord::Base
  
  attr_accessible :name

  validates :name, presence: true

  # 
  # Searches an administration by name
  # @param  name [String] Approximate name of an administration
  # 
  # @return [Array] Array of administrations
  def self.search_by_name(name)
    where("name like ?", "%#{name}%")
  end
end
