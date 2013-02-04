class RenameTypeInFeeds < ActiveRecord::Migration
  def self.up
    change_table :entries do |t|
      t.string :url
    end

    change_table :feeds do |t|
      t.string :kind
      t.remove :type
    end
  end

  def self.down
    change_table :entries do |t|
      t.remove :url
    end

    change_table :feeds do |t|
      t.remove :kind
      t.string :type
    end
  end
end
