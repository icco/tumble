class Entry < ActiveRecord::Base
  belongs_to :feed
  belongs_to :post

  def self.avg_per_day
    groups = Entry.all.group_by {|u| u.date.beginning_of_day }
    sum = groups.map {|d| d.count.to_f }.inject(:+)
    size = groups.size
    return sum / size
  end
end
