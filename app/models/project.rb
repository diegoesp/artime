# A project that the paying company is executing inside Greentime
class Project < ActiveRecord::Base
  attr_accessible :name, :active, :deadline, :description

	validates :name, presence: true
	validates :description, presence: true
  validates :active, inclusion: { in: [true, false] }
  validates :deadline, presence: true
  validate :deadline_valid?

  has_many :tasks

  # Prevents deadline from being before today
  def deadline_valid?
    return if self.deadline.nil?

  	if self.deadline < Date.today then
  		errors.add(:deadline, "Deadline cannot be before today");
  	end
  end

end
