class TouristController < ApplicationController
  def index
    #@tourists = Tourist.find(:all)
    params[:page] ||= 1
    @tourists = Tourist.paginate :page => params[:page], :order => 'id DESC'

  end

  def new

  end

  def edit
  end

  def save
    # newt = newtourist
    @newt = Tourist.new(params[:tourist])
    @newt.user_id = current_user.id
    @newt.save!
    redirect_to :action => 'view', :id => @newt.id
  end

  def view
    @tourist = Tourist.find(params[:id])
  end

end
