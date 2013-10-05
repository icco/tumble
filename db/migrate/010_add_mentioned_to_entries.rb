class AddMentionedToEntries < ActiveRecord::Migration
  def self.up
    change_table :entries do |t|
      t.boolean :mentioned, :default => false
    end
  end
  def self.down
    change_table :entries do |t|
      t.remove :mentioned
    end
  end
end
