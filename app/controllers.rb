Tumble.controllers  do
  layout :main

  get :index do
    @posts = Post.order("updated_at DESC").all
    render :index
  end

  get :post, :with => :id do
    @post = Post.where(:id => params[:id]).first
    render :post
  end

  get :login do
    redirect '/auth/identity'
  end

  get :logout do
    session = {}
    redirect url_for(:index)
  end

  post '/auth/identity/callback' do
    logger.devel request.env['omniauth.auth'].inspect

    # TODO(icco): put in users...
    if request.env['omniauth.auth'].info['email'] == 'nat@natwelch.com'
      session[:loggedin] = true
    end

    redirect '/'
  end

  ###
  # Should be admin only...

  get :post do
    if !logged_in?
      redirect url_for(:login)
    end

    @entries = Entry.where(:post_id => nil).order("date DESC")
    render :make_post
  end

  get :feeds do
    if !logged_in?
      redirect url_for(:login)
    end

    @page_lead = "Manage your feeds..."
    @feeds = Feed.all

    render :feeds
  end

  post :rss, :map => '/feed/rss' do
    if !logged_in?
      redirect url_for(:login)
    end

    url = params[:url]

    f = Feed.new
    f.url = url
    f.kind = 'rss'
    f.save

    redirect :feeds
  end

  post :twitter, :map => '/feed/twitter' do
    if !logged_in?
      redirect url_for(:login)
    end

    redirect :feeds
  end

  post :github, :map => '/feed/github' do
    if !logged_in?
      redirect url_for(:login)
    end

    redirect :feeds
  end
end
