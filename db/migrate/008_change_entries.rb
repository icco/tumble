class ChangeEntries < ActiveRecord::Migration
  def self.up
    change_column(:entries, :url, :text)
  end

  def self.down
    change_column(:entries, :url, :string)
  end
end
