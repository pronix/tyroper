class Hotel < ActiveRecord::Base
  belongs_to :city
  has_one :country, through => :city
end
