class Tourist < ActiveRecord::Base
  belongs_to :user
  has_many :travel

  def self.per_page
    20
  end

  def self.kir
    "#{self.surname_kir.to_s} #{self.name_kir.to_s}"
  end

  def rekvizit 
    "#{self.surname_kir} #{self.name_kir} #{self.ot4_kir},\nпаспорт гражданина РФ #{self.pasport_ros },\n адрес места жительства: #{self.propiska}\n тел. #{self.phone }"
  end
end
