class CreateCities < ActiveRecord::Migration
  def self.up
    create_table :cities do |t|
      t.text :name, :null => false
    end
  end

  def self.down
    drop_table :cities
  end
end
