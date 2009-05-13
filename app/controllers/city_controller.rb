class CityController < ApplicationController
  auto_complete_for :country, :name
  def index
#    @city = City.find(:all)
    @city_grid = initialize_grid(City,
                                :per_page => 20,
                                :include => :country,
                                :order => 'id'
                                )
  end

  def new
  end

  def edit
  end

  def save
    @country_id = Country.find_by_name(params[:country][:name]).id
    @city = City.new
    @city.name = params['city']['name']
    @city.country_id = @country_id
    @city.save!
    redirect_to :action => 'index'
  end

end
