class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments do |t|
      t.text :name
      t.text :content_type
      t.integer :travel_id
      t.binary :data

      t.timestamps
    end
  end

  def self.down
    drop_table :attachments
  end
end
