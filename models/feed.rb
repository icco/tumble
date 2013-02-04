class Feed < ActiveRecord::Base
  has_many :entries

  def get_entries
    if type == "rss"
      require 'rss'
      require 'open-uri'

      open(self.url) do |rss|
        feed = RSS::Parser.parse(rss)
        puts "Title: #{feed.channel.title}"
        feed.items.each do |item|
          puts "Item: #{item.title}"
        end
      end
    elsif type == "github"
    elsif type == "twitter"
    end
  end
end
