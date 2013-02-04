class AddPostIdToEntries < ActiveRecord::Migration
  def self.up
    change_table :entries do |t|
      t.integer :post_id
    end
  end

  def self.down
    change_table :entries do |t|
      t.remove :post_id
    end
  end
end
