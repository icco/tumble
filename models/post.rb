class Post < ActiveRecord::Base
  has_many :entries, :order => 'date DESC'
end
