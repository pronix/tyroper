class CountryController < ApplicationController
  def index
   @country_grid = initialize_grid(Country, :include => :travelpoint )
  end

  def new
  end

  def edit
    @country = Country.find(params[:id])
  end

  def save
    Country.create(params[:country])
    redirect_to :action => 'index'
  end

end
