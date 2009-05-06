class Travel < ActiveRecord::Base
  belongs_to :user
  has_many :travelpoints
  has_many :tourists
end
