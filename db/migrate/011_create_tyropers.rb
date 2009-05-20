class CreateTyropers < ActiveRecord::Migration
  def self.up
    create_table :tyropers do |t|
      t.text :name
      t.text :shortname
      t.text :adress
      t.text :mailadress
      t.integer :mbt
      t.integer :finobes
      t.text :dogovor
      t.text :orgfinobes
      t.text :adressfinobes
      t.text :mailadressfinobes

      t.timestamps
    end
  end

  def self.down
    drop_table :tyropers
  end
end
