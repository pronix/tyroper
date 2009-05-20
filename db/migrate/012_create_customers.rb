class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
      t.text :name
      t.text :yur_adress
      t.text :fiz_adress
      t.text :phone
      t.text :ogrn
      t.text :inn
      t.text :kpp
      t.text :r_s4
      t.text :bank
      t.text :bik
      t.text :director

      t.timestamps
    end
  end

  def self.down
    drop_table :customers
  end
end
