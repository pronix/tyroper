class CreateFoodtypes < ActiveRecord::Migration
  def self.up
    create_table :foodtypes do |t|
      t.text :name, :null => false
      t.text :description
    end
  end

  def self.down
    drop_table :foodtypes
  end
end
