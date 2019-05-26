class PersonController < ApplicationController
  skip_before_action :verify_authenticity_token

  # CREATE
  def new
    @person = Person.new
  end
  def create
    @person = Person.new
    @person.person_id = params[:person_id]
    @person.name = params[:name]
    @person.job = params[:job]
    @person.birthday = params[:birthday]
    @person.biography = omit_string(params[:biography])
    @person.profile_path = params[:profile_path]
    @person.save
    
    if params[:api_call] == 'false'
      redirect_to '/people'
    else
      render status: 200, json: {
        message: "[COMPLETE] The PERSON##{params[:person_id]} is created."
      }.to_json
    end
  end
  
  # READ
  def index
    @people = Person.order('RAND()').all
    @number_of_people = @people.count
  end
  def show
      @person = Person.find(params[:person_id])
      @movies = @person.movies.all
      @tvs = @person.tvs.all
  end    
  
  # UPDATE
  def edit
    @person = Person.find(params[:person_id])
    @movies = @person.movies.all
    @tvs = @person.tvs.all
  end
  def update
    @person = Person.find(params[:person_id])
    @person.name = params[:name]
    @person.job = params[:job]
    @person.birthday = params[:birthday]
    @person.biography = omit_string(params[:biography])
    @person.profile_path = params[:profile_path]
    @person.save

    redirect_to '/people/'+params[:person_id]
  end

  # DELETE
  def destroy
    @person = Person.find(params[:person_id])
    @person.destroy

    redirect_to '/people'
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
