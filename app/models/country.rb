class Country < ActiveRecord::Base
  has_many :hotel, :through => :city
  has_many :city
  accepts_nested_attributes_for :city, :reject_if => proc { |attributes| attributes['name'].blank? }
  has_many :travelpoint

end
