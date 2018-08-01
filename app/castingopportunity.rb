class CastingOpportunity < ActiveRecord::Base
  belongs_to :producer
  has_many :castingrequests
end
