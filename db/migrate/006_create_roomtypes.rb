class CreateRoomtypes < ActiveRecord::Migration
  def self.up
    create_table :roomtypes do |t|
      t.text :name, :null => false
      t.text :description
    end
  end

  def self.down
    drop_table :roomtypes
  end
end
