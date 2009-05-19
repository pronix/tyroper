class Travelpoint < ActiveRecord::Base
  belongs_to :travel
  belongs_to :city
  belongs_to :country
  belongs_to :hotel
  belongs_to :roomtype
  belongs_to :foodtype
end
