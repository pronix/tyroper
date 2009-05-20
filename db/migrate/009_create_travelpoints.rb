class CreateTravelpoints < ActiveRecord::Migration
  def self.up
    create_table :travelpoints do |t|
      t.integer :city_id, :null => false
      t.integer :country_id, :null => false
      t.integer :hotel_id, :null => false
      t.integer :roomtype_id
      t.integer :foodtype_id
      t.date :date_start
      t.date :date_end      
      t.integer :travel_id

      t.timestamps
    end
  end

  def self.down
    drop_table :travelpoints
  end
end
