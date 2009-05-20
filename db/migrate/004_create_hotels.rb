class CreateHotels < ActiveRecord::Migration
  def self.up
    create_table :hotels do |t|
      t.text :name, :null => false
      t.text :description
      t.integer :city_id, :null => false
      t.integer :country_id , :null => false
    end
  end

  def self.down
    drop_table :hotels
  end
end
