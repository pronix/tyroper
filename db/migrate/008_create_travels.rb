class CreateTravels < ActiveRecord::Migration
  def self.up
    create_table :travels do |t|
      t.integer :cena, :null => false
      t.integer :predoplata
      t.text :predoplata_type
      t.integer :doplata
      t.text :doplata_type
      t.text :description
      t.integer :tyroperator_pay # оплата оператору
      t.integer :tyroperator_id 
      t.integer :podtv # id загруженого файла 
      t.integer :s4et # id загруженого файла
      t.integer :platezhka # id загруженого файла
      t.integer :pay_tourist_id, :null => false
      t.integer :user_id, :null => false
      t.text :tourists_array


      t.timestamps
    end
  end

  def self.down
    drop_table :travels
  end
end
