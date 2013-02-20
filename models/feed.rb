class Feed < ActiveRecord::Base
  has_many :entries
  #validates :url, url: true

  def get_entries
    if self.kind == "rss"
      require 'open-uri'
      require 'rss'

      open(self.url) do |rss|
        feed = RSS::Parser.parse(rss)
        feed.items.each do |item|
          e = Entry.find_or_create_by_url item.link
          e.feed = self
          e.title = item.title
          e.date = item.date
          e.raw = item.to_json
          e.save

          logger.push "Inserted Entry #{e.inspect}", :info
        end
      end
    elsif self.kind == "github"
    elsif self.kind == "twitter"
      data = JSON.parse(self.data)
      client = Twitter::Client.new(
        :oauth_token => data["token"],
        :oauth_token_secret => data["secret"],
      )

      client.favorites(self.url).each do |tweet|
        url = "https://twitter.com/#{tweet.user.screen_name}/status/#{tweet.id}"

        e = Entry.find_or_create_by_url url
        e.feed = self
        e.title = tweet.text
        e.date = tweet.created_at
        e.raw = tweet.to_json
        e.save

        logger.push "Inserted Entry #{e.inspect}", :info
      end
    end
  end
end
