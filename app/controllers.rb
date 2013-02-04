Tumble.controllers  do
  layout :main

  get :index do
    @posts = Post.all.order("modified_at DESC")
    render :index
  end

  get :post, :with => :id do
    @post = Post.where(:id => params[:id]).first
    render :post
  end

  ###
  # Should be admin only...

  get :post do
    @entries = Entry.where(:post_id => nil).order("date DESC")
    render :make_post
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
