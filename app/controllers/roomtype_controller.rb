class RoomtypeController < ApplicationController
  def new
  end

  def save
    Roomtype.create(params['roomtype'])
    redirect_to :action => :index

  end

  def edit
    @rtype = Roomtype.find_by_id(params[:id])
  end

  def delete
    Roomtype.delete(params[:id])
    redirect_to :action => 'index'
  end

  def index
    @rtype_grid = initialize_grid(Roomtype,
                                 :order => 'id',
                                 :order_direction => 'desc')
  end

end
