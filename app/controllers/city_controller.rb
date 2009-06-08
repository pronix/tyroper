class CityController < ApplicationController
  auto_complete_for :country, :name
  def index
    @city_grid = initialize_grid(City,
                                :per_page => 20,
                                :include => :country,
                                :order => 'id'
                                )
  end

  def new
  end

  def edit
    @city = City.find_by_id(params[:id])
  end

  def update 
    City.update(params[:id], { :name => params[:city][:name], :country_name  => params[:country][:name] })
    redirect_to :action => 'index'

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
