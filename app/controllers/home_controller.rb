class HomeController < ApplicationController
  def index
    @movies = Movie.where.not("poster_path IS ?", nil).order('RAND()').first(3)
    @tvs = Tv.where.not("poster_path IS ?", nil).order('RAND()').first(3)
    @people = Person.where.not("profile_path IS ?", nil).order('RAND()').first(3)
  end
end
