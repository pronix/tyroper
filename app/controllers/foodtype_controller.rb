class FoodtypeController < ApplicationController
  def new
  end

  def save
    Foodtype.create(params['foodtype'])
    redirect_to :action => :index
  end

  def edit
    @ftype = Foodtype.find_by_id(params[:id])
  end

  def delete
    Foodtype.delete(params[:id])
    redirect_to :action => 'index'
  end

  def index
    @ftype_grid = initialize_grid(Foodtype)
  end

  def update
    Foodtype.update(params[:id],params['foodtype'])
  end

end
