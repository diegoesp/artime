# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  admin                  :boolean          default(FALSE), not null
#

# A user for our SASS
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :role_code, :first_name, :last_name, :avatar

  belongs_to :company

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :company, presence: true
  validates :role_code, presence: true
  validates :role_code, inclusion: { in: Role.role_codes }

  has_and_belongs_to_many :projects

  # PaperClip attachment
  has_attached_file :avatar, :styles => { :thumb => "60x60>" }, :default_url => "/assets/missing_avatar.png"

  # Arranges the complete name for the user
  def name
    return "#{first_name} #{last_name}"
  end

  # Returns true if the user is considered a manager in his company and has access to
  # sensitive information
  def manager?
    role_code >= Role::MANAGER
  end

  # If true, user has pending days
  def pending_input?
    self.pending_input[0] > 0
  end

  # Returns two values using standard Ruby double return (array style)
  # 1) pending input days for the user 
  # 2) total input days (userful for calculating percentages)
  # First return value can be zero, in which case user has no pending days
  def pending_input
    date_to = Date.today
    date_from = Date.today - 4.weeks

    # Backtrack to count how many days we have and how many Sundays and
    # Saturdays we have to exclude    
    date = date_to

    days = 0
    excluded_dates = []
    date = date_to
    while date >= date_from do
      if (date.wday == 0 or date.wday == 6) then
        excluded_dates << date
      else
        days += 1
      end
      date = date - 1
    end

    # Format the excluded dates to fit them in the query
    excluded_dates = excluded_dates.map { |excluded_date| "'#{excluded_date}'"}
    excluded_dates_joined = excluded_dates.join(",")

    # How many days the user has filled ?
    input_days_hash = Input.where("user_id = #{self.id} AND input_date >= '#{date_from}' AND input_date <= '#{date_to}' AND input_date NOT IN (#{excluded_dates_joined})").group("input_date").count
    # Take into account more than one input for the same day (that still counts as only one input for this analysis)
    input_days = input_days_hash.keys.length

    # How many days the user should have filled ?
    days = (date_to - date_from).to_i - excluded_dates.length

    [days - input_days, days]
  end

end