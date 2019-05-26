class MovieController < ApplicationController
  skip_before_action :verify_authenticity_token

  # CREATE
  def new
    @movie = Movie.new
  end
  def create
    @movie = Movie.new
    @movie.movie_id = params[:movie_id]
    @movie.title = params[:title]
    @movie.rating = params[:rating]
    @movie.overview = omit_string(params[:overview])
    @movie.poster_path = params[:poster_path]
    @movie.save
    
    # redirect_to '/movie'
    
    render status: 200, json: {
      message: "THE MOVIE##{params[:movie_id]} CREATE COMPLETE."
    }.to_json
  end

  # READ
  def index
    @movies = Movie.order('RAND()').all
    @number_of_movies = @movies.count
  end
  def show
    @movie = Movie.find(params[:movie_id])
    @cast = @movie.people.where("role = ?", "cast")
    @crew = @movie.people.where("role = ?", "crew")
  end

  # UPDATE
  def edit
    @movie = Movie.find(params[:movie_id])
    @people = @movie.people.all
  end
  def update
    @movie = Movie.find(params[:movie_id])
    @movie.title = params[:title]
    @movie.rating = params[:rating]
    @movie.overview = omit_string(params[:overview])
    @movie.poster_path = params[:poster_path]
    @movie.save

    redirect_to '/movies/'+params[:movie_id]
  end

  # DELETE
  def destroy
    @movie = Movie.find(params[:movie_id])
    @movie.destroy

    redirect_to '/movies'
  end

  # HELPER FUCTION
  private
    def omit_string(string, n=370)
      if string.length == 0
        string = "It does not exist ... "
      elsif string.length > n
        string = string[0..n].concat(" ... ")
      end
        return string
    end
end
