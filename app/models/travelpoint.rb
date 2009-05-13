class Travelpoint < ActiveRecord::Base
  belongs_to :travel
  belongs_to :city
  belongs_to :country
  belongs_to :hotel
end
