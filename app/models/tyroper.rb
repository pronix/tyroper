class Tyroper < ActiveRecord::Base
  has_many :travel

  def info
    self.name + ' ' + self.shortname + ' Адрес(местонахождения):'+ self.adress + "\n" + \
      self.mailadress + 'Финансовое обеспечение: Договор о страховании гражданской ответственности Туроператора за неисполнение или не надлежащее исполнение обязательств по реализации Туристского продукта ' + self.mbt.to_s + "\n" + \
      ' на сумму' + self.finobes.to_s + ' '+ self.dogovor.to_s + " \n Страховой гарант"+ self.orgfinobes + \
      " \n Адрес:"+ self.adressfinobes + ' ' + self.mailadressfinobes
  end
end
