class Feed < ActiveRecord::Base

  def self.get_entries url
    require 'rss'
    require 'open-uri'

    open(url) do |rss|
      feed = RSS::Parser.parse(rss)
      puts "Title: #{feed.channel.title}"
      feed.items.each do |item|
        puts "Item: #{item.title}"
      end
    end
  end
end
