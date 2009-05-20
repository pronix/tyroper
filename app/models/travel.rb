class Travel < ActiveRecord::Base
  belongs_to :user
  belongs_to :tyroper

  has_many :travelpoint
  accepts_nested_attributes_for :travelpoint

  belongs_to :tourist, :foreign_key => 'pay_tourist_id'

  has_many :attachmets


  def summa
    @@s = 0
    if self.predoplata 
      @@s += self.predoplata.to_i
    end
    if self.doplata 
      @@s += self.doplata.to_i
    end
    @@s
  end

  def country
    @@tp = self.travelpoint
    if @@tp.size == 1
     @@tp[0].country.name
    else
      @@tp.empty? ? %q(Не выбрано) : %q(Экскурсионный тур)
    end
  end

  def paycolor
      if self.predoplata 
        self.summa == self.cena ? %q(green) : %q(yellow)
      else
        %q(red)
      end
  end

end
