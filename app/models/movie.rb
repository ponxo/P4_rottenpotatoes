class Movie < ActiveRecord::Base
  class Movie::InvalidKeyError < StandardError ; end
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end

  def self.find_por_director(string)
    @peli=Movie.find(string)
    @director=@peli.director
    @pelis_encontradas=Movie.find_all_by_director(@director)
    return @pelis_encontradas

  end

  def self.find_in_tmdb(string)
    Tmdb.api_key = self.api_key
    begin
      @movies = TmdbMovie.find(:title => string)
      if @movies.length== 0
        @movies='1' #devuelvo un 1 sino encuentro ninguna pelicula en TMDb
      end
    rescue ArgumentError => tmdb_error
      begin
        @movies='0' #devuelve un 0 si es excepcion Movie::InvalidKeyError o RuntimeError
        raise Movie::InvalidKeyError, tmdb_error.message
      rescue Movie::InvalidKeyError, err
      end
    rescue RuntimeError => tmdb_error
      if tmdb_error.message =~ /status code '404'/
        begin
          @movies='0'
          raise Movie::InvalidKeyError, tmdb_error.message
        rescue Movie::InvalidKeyError, err
        end  
      else
        begin
          @movies='0'
          raise RuntimeError, tmdb_error.message
        rescue RuntimeError, err
        end
      end
    end
    return @movies
  end

  def self.api_key
    'fac48ad692c906c5fd854ce583fd998c'
  end
end
