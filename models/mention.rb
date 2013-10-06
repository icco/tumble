class Mention < ActiveRecord::Base
  belongs_to :post
  validates :url, url: true

  def text
    return self.title || self.url
  end
end
