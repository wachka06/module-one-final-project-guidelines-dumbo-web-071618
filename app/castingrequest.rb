class CastingRequest < ActiveRecord::Base
  belongs_to :actor
  belongs_to :producer
  has_one :castingopportunity
end
