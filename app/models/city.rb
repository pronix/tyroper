class City < ActiveRecord::Base
  belongs_to :country
  has_many :hotel
  accepts_nested_attributes_for :hotel
  attr_accessible :country_name
  has_many :travelpoint

  def country_name=(name)
    self.country_id = Country.find_by_name(name).id
  end
end
