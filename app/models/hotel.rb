class Hotel < ActiveRecord::Base
  belongs_to :city
  belongs_to :country
  has_many :travelpoint
end
