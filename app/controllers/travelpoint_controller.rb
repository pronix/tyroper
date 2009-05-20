class TravelpointController < ApplicationController
  layout nil

  def new
    @nom = 0
  end

  def city_select
    if params[:item] =~ /^\d*$/ and params[:item]!= ""
      @nom = params[:id]
      @city = City.find(:all, :conditions => [ "country_id = ?", params[:item] ])
      if @city.empty? 
        @city = Array.new << City.new("id" => '0', 'name' => 'пусто')
      end
    else
        @city = Array.new << City.new("id" => '0', 'name' => 'пусто')
    end
  end
  def hotel_select
    if params[:item] =~ /^\d*$/ and params[:item]!= ""
      @nom = params[:id]
      @hotel = Hotel.find(:all, :conditions => [ "city_id = ?", params[:item] ])
    if @hotel.empty?
      @hotel = Array.new << Hotel.new("id" => '0', 'name' => 'пусто')
    end
    else
      @hotel = Array.new << Hotel.new("id" => '0', 'name' => 'пусто')
    end
  end

  def new_point
    @nom = params[:id]
    render :update do |page|
        page.insert_html :after, "travp#{@nom}", :file => 'travelpoint/new.html.erb'
        page.visual_effect :highlight, "travp#{@nom}"
    end
  end

  def remove_tp
    render :update do |page|
      page.replace_html "travp#{params[:id]}"
    end
  end
end
