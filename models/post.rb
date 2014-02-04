class Post < ActiveRecord::Base
  has_many :entries, :order => 'date DESC'
  has_many :mentions, :order => 'created_at DESC'

  # Clears feed cache and sends web mentions
  after_save do |i|
    Tumble.cache.delete(:feed)
    i.entries.each do |e|
      source = "http://tumble.io/post/#{i.id}"
      target = e.url

      endpoint = Webmention::Client.supports_webmention? target
      if endpoint 
        Webmention::Client.send_mention endpoint, source, target
      end

      e.mentioned = true
      e.save
    end
  end

  def add_mention url
    m = Mention.new
    m.post = self
    m.url = url

    return m.save
  end

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
    groups = Post.all.group_by {|u| u.created_at.beginning_of_day }
    values = groups.map {|k, v| v.count.to_f }
    sum = values.inject(:+)
    size = (Time.now - groups.keys.min) / 86400 # Seconds in a day
    return (sum / size).round(1)
  end

  def self.avg_words
    posts = Post.all.map {|p| p.text.split.count.to_f }
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
