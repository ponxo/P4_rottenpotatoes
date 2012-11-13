class SessionsController < ApplicationController
  # user shouldn't have to be logged in before logging in!
  skip_before_filter :set_current_user

  def create
    auth = request.env["omniauth.auth"]
    user = Moviegoer.find_by_provider_and_uid(auth["provider"], auth["uid"]) || Moviegoer.create_with_omniauth(auth)
    session[:user_id] = user.id
    if session[:action]=='new'
      #session.delete[:action]
      redirect_to new_movie_path
    elsif session[:action]=='edit'
      #session.delete[:action]
      redirect_to "/movies/#{session[:id]}/edit"
    elsif session[:action]=='destroy'
      #session.delete[:action]
      redirect_to movie_path(:id => session[:id]), :method =>:delete 
    elsif session[:action]=='create'
      #session.delete[:action]
      redirect_to movies_path
    end
  end

  def destroy
    session.delete(:user_id)
    flash[:notice] = 'Logged out succesfully'
    redirect_to movies_path
  end

  def login
    redirect_to "/auth/twitter?force_login=true" 

  end
end
