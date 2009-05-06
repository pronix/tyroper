class CreateTravels < ActiveRecord::Migration
  def self.up
    create_table :travels do |t|
      t.binary :platezhka, :limit => 2.megabytes
      t.binary :podtver, :limit => 2.megabytes


      t.timestamps
    end
  end

  def self.down
    drop_table :travels
  end
end
