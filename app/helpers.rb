# Helper methods defined here can be accessed in any controller or view in the application

Tumble.helpers do
  def logged_in?
    return session[:loggedin] === true
  end
end
