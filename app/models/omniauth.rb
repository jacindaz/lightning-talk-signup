def authorize!
  unless signed_in?
    flash[:notice] = "You need to sign in."
    redirect '/'
  end
end

helpers do
  def current_user
    @current_user ||= session['uid']
  end

  def signed_in?
    !current_user.nil?
  end
end
