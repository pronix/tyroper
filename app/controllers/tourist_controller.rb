class TouristController < ApplicationController
  def index
    #@tourists = Tourist.find(:all)
    # params[:page] ||= 1
    # @tourists = Tourist.paginate :page => params[:page], :order => 'id DESC'

    @tourists_grid = initialize_grid(Tourist,
                                    :per_page => 20,
                                    :order => 'created_at',
                                    :order_direction => 'desc',
                                    :include => :user
                                    )

  end

  def new

  end

  def edit
    @tourist = Tourist.find_by_id(params[:id])
  end

  def update 
    Tourist.update(params[:id], params[:tourist])
    #redirect_to :action => 'view', :id => params[:id]
    redirect_to :action => 'index'
  end

  def save
    # newt = newtourist
    @newt = Tourist.new(params[:tourist])
    @newt.user_id = session[:user]
    @newt.save!
    redirect_to :action => 'view', :id => @newt.id
  end

  def view
    @tourist = Tourist.find(params[:id])
  end

end
