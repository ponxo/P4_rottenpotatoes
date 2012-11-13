class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_current_user, :except => ['login','index','show','search_tmdb','search_by_director','create']
  protected # prevents method from being invoked by a route
  def set_current_user
    # we exploit the fact that find_by_id(nil) returns nil
    puts "Action e ID en el filtro"
    session[:action]=params[:action]
    session[:id]=params[:id]
    puts session[:action]
    puts session[:id]
    @current_user ||= Moviegoer.find_by_id(session[:user_id])
    redirect_to '/login' and return unless @current_user
  end
end
