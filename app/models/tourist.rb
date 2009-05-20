class Tourist < ActiveRecord::Base
  belongs_to :user
  has_many :travel

  def self.per_page
    20
  end

  def self.kir
    self.surname_kir.to_s +' '+ self.name_kir.to_s
  end

end
