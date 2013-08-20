# Helper methods defined here can be accessed in any controller or view in the application

Tumble.helpers do
  def logged_in?
    return session[:loggedin] === true
  end

  def t time
    zone_name = "America/Los_Angeles"
    zone = ActiveSupport::TimeZone[zone_name]
    time = zone.at(time)
    return "<time rel=\"tooltip\" title=\"#{time.to_s(:full)}\" datetime=\"#{time.iso8601}\">#{time_ago_in_words time} ago</time>"
  end

  def ago time
    return "#{time_ago_in_words time} ago"
  end

  def m text
    r = Redcarpet::Markdown.new(
      Redcarpet::Render::HTML.new({:hard_wrap => true}),
      :autolink => true,
      :space_after_headers => true,
      :fenced_code_blocks => true
    )

    # Render Markdown
    out = r.render text

    # Link twitter
    out = out.gsub(/@(\w+)/) {|a| "<a href=\"http://twitter.com/#{a[1..-1]}\"/>#{a}</a>" }

    return out
  end
end
