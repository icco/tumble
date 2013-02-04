Tumble.controllers  do
  layout :main

  get :index do
    @posts = Post.all.order("modified_at DESC")
    render :index
  end

  get :feeds do
    @page_lead = "Manage your feeds..."
    render :feeds
  end

  post :rss, :map => '/feed/rss' do
    url = params[:url]

    f = Feed.new
    f.url = url
    f.type = 'rss'
    f.save

    redirect :feeds
  end

  post :twitter, :map => '/feed/twitter' do
    redirect :feeds
  end

  post :github, :map => '/feed/github' do
    redirect :feeds
  end
end
