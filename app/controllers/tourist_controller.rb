class TouristController < ApplicationController
  def index
    @tourists_grid = initialize_grid(Tourist,
                                    :per_page => 20,
                                    :order => 'created_at',
                                    :order_direction => 'desc',
                                    :include => :user
                                    )
  end

  def new
    @tourist = Tourist.new
  end


  def edit
    @tourist = Tourist.find_by_id(params[:id])
  end

  def update 
    Tourist.update(params[:id], params[:tourist])
    redirect_to :action => 'index'
  end

  def save
    @newt = Tourist.new(params[:tourist])
    @newt.user_id = session[:user]
    @newt.save!
    redirect_to :action => 'view', :id => @newt.id
#    render :file => 'app/views/tourist/new.html.erb', :layout => 'menu'
  end

  def save
    if params[:id].empty?
      @newt = Tourist.new(params[:tourist])
      @newt.user_id = session[:user]
    else
      @newt = Tourist.find_by_id(params[:id])
      params['tourist'].each do |key,val|
       @newt[key] = val
      end
    end
    if @newt.save!
      flash[:notice] = 'Сохранен турист'
    else
      flash[:error] = 'Произошла ошибка при сохранении туриста'
    end
    redirect_to :action => 'index', :id => @newt.id
  end

  def view
    @tourist = Tourist.find(params[:id])
  end

end
