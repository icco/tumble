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
end
