class MovieCreditController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @movieCredits = MovieCredit.all
  end

  def create
    @movieCredit = MovieCredit.new
    @movieCredit.movie_id = params[:movie_id]
    @movieCredit.person_id = params[:person_id]
    @movieCredit.role = params[:role]
    @movieCredit.save

    render status: 200, json: {
      message: "THE MOVIE_CREDIT##{params[:movie_id]}-#{params[:person_id]} CREATE COMPLETE."
    }.to_json
  end
end
