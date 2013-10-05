class Mention < ActiveRecord::Base
  belongs_to :post
  validates :url, url: true

end
