class Feed < ActiveRecord::Base
  has_many :entries
  validates :url, url: true

  def get_entries
    if self.kind == "rss"
      require 'rss'
      require 'open-uri'

      open(self.url) do |rss|
        feed = RSS::Parser.parse(rss)
        feed.items.each do |item|
          p item.title, item.date, item.to_json

          e = Entry.find_or_create_by_url item.link
          e.feed = self
          e.title = item.title
          e.date = item.date
          e.raw = item.to_json
          e.save
        end
      end
    elsif self.kind == "github"
    elsif self.kind == "twitter"
    end
  end
end
