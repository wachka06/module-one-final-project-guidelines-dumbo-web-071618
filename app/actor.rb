class Actor < ActiveRecord::Base
  has_many :casting_requests
  has_many :producers, through: :casting_opportunitys

  def full_name
    "#{first_name} #{last_name}"
  end

  def list_opportunities
    CastingOpportunity.all
  end
end
