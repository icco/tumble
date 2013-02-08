Tumble.controllers  do
  layout :main

  get :index do
    @posts = Post.order("updated_at DESC").all
    render :index
  end

  get '/test' do
    @posts = Post.order("updated_at DESC").all
    render :index, :layout => :new
  end

  get :post, :with => :id do
    @post = Post.where(:id => params[:id]).first
    render :post
  end

  get :about do
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

    @page_lead = "Create a new post..."
    @entries = Entry.where(:post_id => nil).order("date DESC")
    render :make_post
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

    render :feeds
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

    redirect :feeds
  end

  post :github, :map => "/feed/github" do
    if !logged_in?
      redirect url_for(:login)
    end

    redirect :feeds
  end
end
