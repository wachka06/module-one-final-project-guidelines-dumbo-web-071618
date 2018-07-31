class Producer < ActiveRecord::Base
  has_many :casting_opportunitys
  has_many :casting_requests
  has_many :actors, through: :casting_opportunitys

  def full_name
    "#{first_name} #{last_name}"
  end

#Change .new to .create after testing line 12
  def create_opportunity(gender, age_range)
    CastingOpportunity.new(gender: gender, age_range: age_range, producer_id: self.id)
  end

  def list_opportunities
    CastingOpportunity.all
  end

end
