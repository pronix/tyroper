class HotelController < ApplicationController
  auto_complete_for :city, :name
  def index
  @hotel_grid = initialize_grid(Hotel, 
                                :include =>  [:city, :country, :travelpoint], 
                                :order => 'name'
                               )
  end

  def new
  end

  def edit
  end

  def save
    unless params[:city][:name].empty?
    @city = City.find_by_name(params[:city][:name])
    params['hotel']['city_id'] = @city.id
    params['hotel']['country_id'] = @city.country_id
    @hotel = Hotel.create(params['hotel'])
    else
      flash[:error] = 'Необходимо указать город в котором находится гостиница'
    end
    redirect_to :action => 'index'

  end
end
