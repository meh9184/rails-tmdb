class TvController < ApplicationController
  skip_before_action :verify_authenticity_token

  # CREATE
  def new
    @tv = Tv.new
  end
  def create
    @tv = Tv.new
    @tv.tv_id = params[:tv_id]
    @tv.name = params[:name]
    @tv.rating = params[:rating]
    @tv.overview = omit_string(params[:overview])
    @tv.poster_path = params[:poster_path]
    @tv.save

    if params[:api_call] == 'false'
      redirect_to '/tvs'
    else
      render status: 200, json: {
        message: "[COMPLETE] The TV##{params[:tv_id]} is created."
      }.to_json
    end
  end

  # READ
  def index
    @tvs = Tv.order('updated_at DESC').all
    @number_of_tvs = @tvs.count
  end
  def show
    @tv = Tv.find(params[:tv_id])
    @cast = @tv.people.where("role = ?", "cast")
    @crew = @tv.people.where("role = ?", "crew")
  end

  # UPDATE
  def edit
    @tv = Tv.find(params[:tv_id])
    @people = @tv.people.all
  end
  def update
    @tv = Tv.find(params[:tv_id])
    @tv.name = params[:name]
    @tv.rating = params[:rating]
    @tv.overview = omit_string(params[:overview])
    @tv.poster_path = params[:poster_path]
    @tv.save

    redirect_to '/tvs/'+params[:tv_id]
  end

  # DELETE
  def destroy
    @tv = Tv.find(params[:tv_id])
    @tv.destroy

    redirect_to '/tvs'
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
