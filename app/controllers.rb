Tumble.controllers  do
  layout :main

  get :index do

    StatHat::API.ez_post_count("tumble.io/index", "nat@natwelch.com", 1)

    @posts = Post.order("updated_at DESC").all
    render :index
  end

  # http://www.ruby-doc.org/stdlib-1.9.3/libdoc/rss/rdoc/RSS.html
  get :feed do
    require "rss"

    StatHat::API.ez_post_count("tumble.io/feed", "nat@natwelch.com", 1)

    @posts = Post.order("updated_at DESC").all

    rss = RSS::Maker.make("atom") do |maker|
      maker.channel.author = "Nat Welch"
      maker.channel.updated = Post.maximum(:updated_at)
      maker.channel.about = "A bunch of random thoughts tumbling for the author's head."
      maker.channel.title = "Tumble.io"

      maker.items.do_sort = true

      @posts.each do |p|
        maker.items.new_item do |item|
          item.link = "http://tumble.io#{url_for(:post, :id => p.id)}"
          item.title = p.created_at.to_s(:full)
          item.updated = p.updated_at
          item.content.content = m(p.summary)
          item.content.type = "html"
        end
      end
    end

    content_type "application/atom+xml"
    return rss.to_s
  end

  get :post, :with => :id do
    @post = Post.where(:id => params[:id]).first
    @title = "Post #{@post.id}"
    render :post
  end

  get :about do
    @avgs = {
      :posts => Post.avg_per_day,
      :articles => Entry.avg_per_day
    }

    render :about
  end

  get :login do
    redirect "/auth/identity"
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
    limit ||= 25

    @page_lead = "Create a new post..."
    @entries = Entry.where(:post_id => nil).order("date DESC").limit(limit)

    render :make_post, :layout => :admin
  end

  post :post do
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

    redirect "/"
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
