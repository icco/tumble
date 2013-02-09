class Post < ActiveRecord::Base
  has_many :entries, :order => 'date DESC'

  # used mainly for rss
  def summary
    entry_text = ""
    self.entries.each do |e|
      entry_text += "<li><a href=\"#{e.url}\">#{e.title}</a></li>"
    end

    return "<div>#{self.text}</div> <ul>#{entry_text}</ul>"
  end

  def self.avg_per_day
    groups = Post.all.group_by {|u| u.created_at.beginning_of_day }
    sum = groups.map {|d| d.count.to_f }.inject(:+)
    size = groups.size
    return sum / size
  end
end
