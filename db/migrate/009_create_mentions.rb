class CreateMentions < ActiveRecord::Migration
  def self.up
    create_table :mentions do |t|
      t.integer :post_id
      t.string :url
      t.string :title
      t.timestamps
    end
  end

  def self.down
    drop_table :mentions
  end
end
