class CreateTourists < ActiveRecord::Migration
  def self.up
    create_table :tourists do |t|
      t.text :name_kir
      t.text :ot4_kir
      t.text :surname_kir
      t.boolean :sex
      t.text :name_lat
      t.text :surname_lat
      t.date :borndate
      t.text :reklama
      t.text :pasport_ros
      t.integer :seriya_zag_pasp
      t.integer :nomer_zag_pasp
      t.text :phone  
      t.timestamps
    end
  end

  def self.down
    drop_table :tourists
  end
end
