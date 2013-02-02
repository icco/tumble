Tumble.controllers  do
  layout :main

  get :index do
    render :index
  end

  get :feeds do

    render :feeds
  end

  post :feeds do

    redirect :feeds
  end
end
