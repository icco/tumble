class Post < ActiveRecord::Base
  has_many :entries, :order => 'date DESC'

  # Clears feed cache
  after_save {|i| Tumble.cache.delete(:feed) }

  # used mainly for rss
  def summary
    entry_text = "\n"
    self.entries.each do |e|
      entry_text += " * [#{e.title}](#{e.url})\n"
    end

    return "#{self.text} \n\n #{entry_text}\n"
  end

  def sha1
    require 'digest/sha1'
    return Digest::SHA1.hexdigest(self.summary)
  end

  def self.avg_per_day
    groups = Post.all.group_by {|u| u.created_at.beginning_of_day }.map {|k, v| v.count.to_f }
    sum = groups.inject(:+)
    size = groups.size
    return (sum / size).round(1)
  end

  def self.avg_words
    posts = Post.all.map {|p| p.text.split.count }
    sum = posts.inject(:+)
    size = Post.all.count
    return (sum / size).round(1)
  end

  def self.avg_links
    groups = Entry.where("post_id IS NOT NULL").group_by {|u| u.post_id }.map {|k, v| v.count.to_f }
    sum = groups.inject(:+)
    size = groups.size
    return (sum / size).round(1)
  end
end
