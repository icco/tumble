class AddFieldsToFeedsAndEntries < ActiveRecord::Migration
  def self.up
    change_table :feeds do |t|
      t.string :type
      t.text :data
    end

    change_table :entries do |t|
      t.text :raw
    end
  end

  def self.down
    change_table :feeds do |t|
      t.remove :type
      t.remove :data
    end

    change_table :entries do |t|
      t.remove :raw
    end
  end
end
