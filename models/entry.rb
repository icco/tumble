class Entry < ActiveRecord::Base
  belongs_to :feed
  belongs_to :post

  def self.avg_per_day
    groups = Entry.all.group_by {|u| u.date.beginning_of_day }.map {|k, v| v.count.to_f }
    sum = groups.inject(:+)
    size = groups.size
    return (sum / size).round(1)
  end
end
