class AddMentionedToEntries < ActiveRecord::Migration
  def self.change
    change_table :entries do |t|
      t.boolean :mentioned, :default => false
    end
  end
end
