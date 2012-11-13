require 'spec_helper'
describe Movie do
    describe 'searching Tmdb by keyword' do
    it 'should call Tmdb with title keywords given valid API key' do
      fake_movies = [mock('Movie'), mock('Movie')]
      TmdbMovie.should_receive(:find).with(hash_including :title => 'Inception').and_return(fake_movies)
      Movie.find_in_tmdb('Inception')
      fake_movies.stub(:length).and_return(100)
      
    end
    it 'should raise an InvalidKeyError with no API key' do
      Movie.stub(:api_key).and_return('')
      @movies.stub(:length).and_return(100)
      lambda { Movie.find_in_tmdb('Inception') }.
        should raise_error(Movie::InvalidKeyError)
    end
    it 'should raise an InvalidKeyError with invalid API key' do
      TmdbMovie.stub(:find).
        and_raise(RuntimeError.new("API returned status code '404'"))
      lambda { Movie.find_in_tmdb('Inception') }.
        should raise_error(Movie::InvalidKeyError)
    end

  end
end

