# Helper methods defined here can be accessed in any controller or view in the application

Tumble.helpers do
  def logged_in?
    return session[:loggedin] === true
  end

  def t time
    return "<time datetime=\"#{time.iso8601}\">#{time.to_s(:short)}</time>"
  end

  def m text
    r = Redcarpet::Markdown.new(
      Redcarpet::Render::HTML.new({:hard_wrap => true}),
      :autolink => true,
      :space_after_headers => true,
      :fenced_code_blocks => true
    )

    return r.render(text)
  end
end
