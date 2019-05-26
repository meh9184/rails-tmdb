class TvCreditController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @movieCredits = MovieCredit.all
  end

  def create
    @tvCredit = TvCredit.new
    @tvCredit.tv_id = params[:tv_id]
    @tvCredit.person_id = params[:person_id]
    @tvCredit.role = params[:role]
    @tvCredit.save

    render status: 200, json: {
      message: "[COMPLETE] The TV_CREDIT##{params[:tv_id]}-#{params[:person_id]} is created."
    }.to_json
  end
end
