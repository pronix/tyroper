class CreateTyropers < ActiveRecord::Migration
  def self.up
    create_table :tyropers do |t|
      t.text :name, :null => false
      t.text :shortname, :null => false
      t.text :adress, :null => false
      t.text :mailadress, :default => ''
      t.integer :mbt, :null => false
      t.integer :finobes, :null => false
      t.text :dogovor, :default => ''
      t.text :orgfinobes, :default => ''
      t.text :adressfinobes, :default => ''
      t.text :mailadressfinobes, :default => ''

      t.timestamps
    end
  end

  def self.down
    drop_table :tyropers
  end
end
