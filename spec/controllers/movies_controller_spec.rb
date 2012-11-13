require 'spec_helper'

describe MoviesController do
  describe 'Buscador de otras peliculas del mismo director' do
    it 'No hay info del director disponible para mostrar mas peliculas' do
      fake_movies = [mock('Movie'), mock('Movie')]
      fake_movie = [mock('Movie')]
      Movie.should_receive(:find_por_director).and_return(fake_movies)
      Movie.should_receive(:find).and_return(fake_movie)
      fake_movies.stub(:length).and_return(1)
      fake_movie.stub(:title).and_return('Alien')
      post :search_by_director ,{:id =>'3'}
    end
    it 'Vamos a comprobar que llamamos al metodo Movie.find_por director y devuelve las peliculas' do
      fake_movies = [mock('Movie'), mock('Movie')]
      fake_movie = [mock('Movie')]
      Movie.should_receive(:find_por_director).and_return(fake_movies)
      Movie.should_receive(:find).and_return(fake_movie)
      fake_movies.stub(:length).and_return(100)
      post :search_by_director ,{:id =>'3'}
    end
    it 'Tenemos que ver los resultados en search_by_director' do
      fake_movies = [mock('Movie'), mock('Movie')]
      fake_movie = [mock('Movie')]
      Movie.should_receive(:find_por_director).and_return(fake_movies)
      Movie.should_receive(:find).and_return(fake_movie)
      fake_movies.stub(:length).and_return(100)
      post :search_by_director ,{:id =>'3'}
      response.should render_template("search_by_director")
    end
    it 'Tenemos que ver en la vista los resultados delvueltos por el modelo' do
      fake_movies = [mock('Movie'), mock('Movie')]
      fake_movie = [mock('Movie')]
      Movie.stub(:find_por_director).and_return(fake_movies)
      Movie.should_receive(:find).and_return(fake_movie)
      fake_movies.stub(:length).and_return(100)
      post :search_by_director ,{:id =>'3'}
      assigns(:movies).should == fake_movies
    end
  end
  describe 'Buscador de peliculas en Search TMDB' do
    it 'Se llama al metodo en el modelo find_in_tmdb' do
      Movie.should_receive(:find_in_tmdb).with('hardware')
      post :search_tmdb,{:search_terms => 'hardware'}
    end
    it 'Se encuentran peliculas y veo su vista' do
      fake_movies = [mock('Movie'), mock('Movie')]
      Movie.stub(:find_in_tmdb).and_return(fake_movies)
      post :search_tmdb, {:search_terms => 'hardware'}
      response.should render_template('search_tmdb')
    end
    it 'Ha habido un error Movie::InvalidKeyError' do
      fake_results = '0'
      Movie.stub(:find_in_tmdb).and_return(fake_results)
      post :search_tmdb, {:search_terms => 'hardware'}
      assigns(:movies).should == fake_results
      render_template('index')
    end
     it 'No se han encontrado resultados para la pelicula buscada' do
      fake_results = '1'
      Movie.stub(:find_in_tmdb).and_return(fake_results)
      post :search_tmdb, {:search_terms => 'hardware'}
      assigns(:movies).should == fake_results
      render_template('index')
    end
  end
  describe 'show' do
    it 'Funcionamiento show' do
      fake_movies = [mock('Movie'), mock('Movie')]
      Movie.should_receive(:find).with('2').and_return(fake_movies)
      Moviegoer.should_receive(:find_by_id).with(session[:user_id])  
      post :show, {:id => '2'}
    end
  end
  describe 'edit' do
    it 'Funcionamiento edit' do
      Movie.stub(:find_by_id).with('2')
      post :edit, {:id => '2'}
    end
  end
  describe 'create' do
    it 'Funcionamiento Create' do
      Movie.stub(:create)
      post :create
      render_template('index')
    end
  end
end
