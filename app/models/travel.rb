class Travel < ActiveRecord::Base
  belongs_to :user

  has_many :travelpoint
  accepts_nested_attributes_for :travelpoint

  belongs_to :tourist, :foreign_key => 'pay_tourist_id'

  has_many :attachmets


  def summa
    @s = 0
    if self.predoplata =~ /\d/
      @s += self.predoplata.to_i
    end
    if self.doplata =~ /\d/
      @s += self.doplata.to_i
    end
    @s
  end
end
