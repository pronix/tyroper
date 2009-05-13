class CreateTravels < ActiveRecord::Migration
  def self.up
    create_table :travels do |t|
      t.integer :cena
      t.text :predoplata 
      t.text :predoplata_type
      t.text :doplata
      t.text :doplata_type
      t.text :description
      t.integer :podtv # id загруженого файла 
      t.integer :s4et # id загруженого файла
      t.integer :platezhka # id загруженого файла
      t.integer :pay_tourist_id
      t.integer :user_id
      t.text :tourists_array


      t.timestamps
    end
  end

  def self.down
    drop_table :travels
  end
end
