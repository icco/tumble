Tumble.controllers  do
  layout :main

  PER_PAGE = 15

  get :index do
    @posts = Post.order("updated_at DESC").limit(PER_PAGE)
    @page_num = 1
    @pages = (Post.count / PER_PAGE) + 1
    render :index
  end

  get :page, :with => :id do
    @page_num = params[:id].to_i
    @pages = (Post.count / PER_PAGE) + 1
    if @page_num < 2 or @page_num > @pages
      redirect url_for(:index)
    else
      offset = PER_PAGE * (@page_num - 1)
      @posts = Post.order("updated_at DESC").limit(PER_PAGE).offset(offset)
      render :index
    end
  end

  get "/all.json" do
    @posts = Post.order("updated_at DESC").all

    ret = []
    @posts.each do |p|
      h = {
        id: p.id,
        datetime: p.updated_at,
        text: p.summary,
        title: p.title,
      }
      ret.push h
    end

    content_type :json
    ret.to_json.gsub(/\n/, "\\\\n").gsub(/\r/, "\\\\r").gsub(/\t/, "\\\\t")
  end

  post :webmention, :csrf_protection => false  do
    content_type :json

    from = URI(params["source"])
    to = URI(params["target"])
    if to.host == request.host
      id = to.path.split("/").delete_if {|i| i.to_i <= 0 }.first
      post = Post.find(id)
      post.add_mention(from.to_s)

      status 202
      { "result" => "WebMention was successful" }.to_json
    else
      status 400
      { 'error' => 'target_not_found' }.to_json
    end
  end

  # http://www.ruby-doc.org/stdlib-1.9.3/libdoc/rss/rdoc/RSS.html
  get :feed do
    require "rss"

    @posts = Post.order("updated_at DESC").all

    rss = RSS::Maker.make("atom") do |maker|
      maker.channel.authors.new_author do |author|
        author.email = "nat@natwelch.com"
        author.name = "Nat Welch"
        author.uri = "http://natwelch.com"
      end
      maker.channel.updated = Post.maximum(:updated_at)
      maker.channel.about = "A bunch of random thoughts tumbling for the author's head."
      maker.channel.title = "Tumble.io"

      maker.items.do_sort = true

      @posts.each do |p|
        maker.items.new_item do |item|
          item.link = "http://tumble.io#{url_for(:post, :id => p.id)}"
          item.title = "Tumble.io Post ##{p.id}"
          item.updated = p.updated_at
          item.content.content = m(p.summary)
          item.content.type = "html"
        end
      end
    end

    etag Digest::SHA1.hexdigest(rss.to_s)
    content_type "application/atom+xml"
    return rss.to_s
  end

  # Creates a simple summary rss feed for ifttt.
  get :"summary.rss" do
    require "rss"

    @posts = Post.order("updated_at DESC").all

    rss = RSS::Maker.make("atom") do |maker|
      maker.channel.authors.new_author do |author|
        author.email = "nat@natwelch.com"
        author.name = "Nat Welch"
        author.uri = "http://natwelch.com"
      end
      maker.channel.updated = Post.maximum(:updated_at)
      maker.channel.about = "A bunch of random thoughts tumbling for the author's head."
      maker.channel.title = "Tumble.io Summaries"

      maker.items.do_sort = true

      @posts.each do |p|
        maker.items.new_item do |item|
          item.link = "http://tumble.io#{url_for(:post, :id => p.id)}"
          item.title = "Tumble.io Post ##{p.id}"
          item.updated = p.updated_at
          # Takes markdown, turns into 100 chars of plain text
          # TODO: Remove HTML entities...
          item.content.content = truncate(strip_tags(m(p.text)), :length => 100).strip
          item.content.type = "text"
        end
      end
    end

    etag Digest::SHA1.hexdigest(rss.to_s)
    content_type "application/atom+xml"
    return rss.to_s
  end

  get :post, :with => :id do
    @post = Post.where(:id => params[:id]).first
    if @post.nil?
      404
    else
      @title = "Post ##{@post.id}"
      etag @post.sha1
      render :post
    end
  end

  get :about do
    @avgs = {
      :posts => Post.avg_per_day,
      :articles => Entry.avg_per_day,
      :words => Post.avg_words,
      :links => Post.avg_links,
    }

    render :about
  end

  get :login do
    render :login, :layout => :admin
  end

  get :logout do
    session.clear
    redirect url_for(:index)
  end

  post "/auth/identity/callback" do
    # TODO(icco): put in users...
    if request.env["omniauth.auth"].info["email"] == "nat@natwelch.com"
      session[:loggedin] = true
    end

    redirect "/"
  end

  ###
  # Should be admin only...

  get :post do
    if !logged_in?
      redirect url_for(:login)
    end

    if params['limit']
      limit = params['limit'].to_i
    end
    limit ||= 30

    if params['offset']
      offset = params['offset'].to_i
    end
    offset ||= 0

    @page_lead = "Create a new post..."
    @entries = Entry.where(:post_id => nil).order("date DESC").limit(limit).offset(offset)

    render :make_post, :layout => :admin
  end

  post :post do
    if !logged_in?
      redirect url_for(:login)
    end

    p = Post.new
    p.text = params["text"]
    p.title = params["title"]
    p.save

    if params["link"]
      params["link"].each do |id|
        e = Entry.find_by_id id.to_i
        e.post = p
        e.save
      end
    end

    redirect url_for(:index)
  end

  get :edit, :with => :id do
    if !logged_in?
      redirect url_for(:login)
    end

    @post = Post.where(:id => params[:id]).first
    @title = "Post #{@post.id}"
    render :edit_post, :layout => :admin
  end

  post :edit, :with => :url_id do
    if !logged_in?
      redirect url_for(:login)
    end

    if params[:url_id] == params["id"]
      @post = Post.where(:id => params[:id]).first
    else
      return 500
    end

    @post.text = params["text"]
    @post.title = params["title"]
    @post.save

    redirect url_for(:post, @post.id)
  end

  get :feeds do
    if !logged_in?
      redirect url_for(:login)
    end

    @page_lead = "Manage your feeds..."
    @feeds = Feed.all

    render :feeds, :layout => :admin
  end

  post :rss, :map => "/feed/rss" do
    if !logged_in?
      redirect url_for(:login)
    end

    url = params[:url]

    f = Feed.new
    f.url = url
    f.kind = "rss"
    f.save

    redirect :feeds
  end

  post :twitter, :map => "/feed/twitter" do
    if !logged_in?
      redirect url_for(:login)
    end

    redirect '/auth/twitter'
  end

  get "/auth/twitter/callback" do
    username = request.env["omniauth.auth"].info["nickname"]

    p request.env["omniauth.auth"].credentials.to_json

    f = Feed.find_or_create_by_url username
    f.kind = "twitter"
    f.data = request.env["omniauth.auth"].credentials.to_json
    f.save

    redirect :feeds
  end

  post :github, :map => "/feed/github" do
    if !logged_in?
      redirect url_for(:login)
    end

    redirect :feeds
  end
end
