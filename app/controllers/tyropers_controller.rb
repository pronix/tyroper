class TyropersController < ApplicationController
  layout 'menu'
  # GET /tyropers
  # GET /tyropers.xml
  def index
    @tyropers = Tyroper.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tyropers }
    end
  end

  # GET /tyropers/1
  # GET /tyropers/1.xml
  def show
    @tyroper = Tyroper.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tyroper }
    end
  end

  # GET /tyropers/new
  # GET /tyropers/new.xml
  def new
    @tyroper = Tyroper.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tyroper }
    end
  end

  # GET /tyropers/1/edit
  def edit
    @tyroper = Tyroper.find(params[:id])
  end

  # POST /tyropers
  # POST /tyropers.xml
  def create
    @tyroper = Tyroper.new(params[:tyroper])

    respond_to do |format|
      if @tyroper.save
        flash[:notice] = 'Tyroper was successfully created.'
        format.html { redirect_to(@tyroper) }
        format.xml  { render :xml => @tyroper, :status => :created, :location => @tyroper }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tyroper.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tyropers/1
  # PUT /tyropers/1.xml
  def update
    @tyroper = Tyroper.find(params[:id])

    respond_to do |format|
      if @tyroper.update_attributes(params[:tyroper])
        flash[:notice] = 'Tyroper was successfully updated.'
        format.html { redirect_to(@tyroper) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tyroper.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tyropers/1
  # DELETE /tyropers/1.xml
  def destroy
    @tyroper = Tyroper.find(params[:id])
    @tyroper.destroy

    respond_to do |format|
      format.html { redirect_to(tyropers_url) }
      format.xml  { head :ok }
    end
  end
end
