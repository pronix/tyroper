class Customer < ActiveRecord::Base
  def rekvizit
    "#{self.name},\n юридический адрес #{self.yur_adress}, \n физический адрес #{self.fiz_adress},\nтелефон #{self.phone}, ОГРН #{self.ogrn}, ИНН #{self.inn}, КПП #{self.kpp},\n расчетный счет #{self.r_s4},\n #{self.bank},\n БИК #{self.bik} "  
  end
end
