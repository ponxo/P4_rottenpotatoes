class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
    @current_user ||= Moviegoer.find_by_id(session[:user_id])
  end

  def index
    sort = params[:sort] || session[:sort]
    case sort
    when 'title'
      ordering,@title_header = {:order => :title}, 'hilite'
    when 'release_date'
      ordering,@date_header = {:order => :release_date}, 'hilite'
    end
    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:ratings] || session[:ratings] || {}
    
    if @selected_ratings == {}
      @selected_ratings = Hash[@all_ratings.map {|rating| [rating, rating]}]
    end
    
    if params[:sort] != session[:sort]
      session[:sort] = sort
      flash.keep
      redirect_to :sort => sort, :ratings => @selected_ratings and return
    end

    if params[:ratings] != session[:ratings] and @selected_ratings != {}
      session[:sort] = sort
      session[:ratings] = @selected_ratings
      flash.keep
      redirect_to :sort => sort, :ratings => @selected_ratings and return
    end
    @movies = Movie.find_all_by_rating(@selected_ratings.keys, ordering)
    @current_user ||= Moviegoer.find_by_id(session[:user_id])
  end

  def new
  end

  def create
    @parametros = params[:movie] || {}
    if @parametros == {}
    # Aqui he llamado al Create desde el buscador de search TMDB
      puts 'Create del Search'
      puts 'Voy a sacar el titulo'
      puts params[:title]
      @movie = Movie.create!(:title => params[:title],:release_date => params[:date], :rating =>'G')
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movies_path
    else
    # Aqui lo llamo desde Add Movie
      @movie = Movie.create!(params[:movie])
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movies_path
    end
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    puts 'Esoy en el DESTROYYYYYYY'
    puts params
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  def search_by_director
    @peli=Movie.find(params[:id])
    @movies=Movie.find_por_director(params[:id])
    if @movies.length==1 #No hay info del director
      flash[:warning]="'#{@peli.title}' has no director info"
      redirect_to movies_path
    else
      @current_user ||= Moviegoer.find_by_id(session[:user_id])
    end
  end


  def search_tmdb
    @movies=Movie.find_in_tmdb(params[:search_terms])
    if @movies == '0'
      flash[:warning] = "Search not Available"
      redirect_to movies_path
    elsif @movies == '1'
      flash[:warning]= "'#{params[:search_terms]}' was not found in TMDb."
      redirect_to movies_path
    end
    @current_user ||= Moviegoer.find_by_id(session[:user_id])
  end
end
