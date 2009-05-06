class CreateHotels < ActiveRecord::Migration
  def self.up
    create_table :hotels do |t|
      t.text :name, :null => false
      t.text :description
    end
  end

  def self.down
    drop_table :hotels
  end
end
