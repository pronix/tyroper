class AccountController < ApplicationController
  layout 'menu', :except => [ :login, :chadmin, :chactive ]
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie

  # say something nice, you goof!  something sweet.
  def index
    redirect_to(:action => 'signup') unless logged_in? || User.count > 0
  end

  def list
    @grid_user = initialize_grid(User,
                                :per_page => 20,
                                :order => 'id')
  end

  def login
    return unless request.post?
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      session[:login] = User.find(self.current_user).login
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_to( :action => 'index')
      flash[:notice] = "Logged in successfully"
    end
  end

  def signup
    if true
#    if User.find(:all, :limit => '1').empty? or self.current_user == User.find(1)
      @user = User.new(params[:user])
      return unless request.post?
      @user.save!
  #    self.current_user = @user
      redirect_back_or_default(:controller => 'tourist', :action => 'index')
      flash[:notice] = "Thanks for signing up!"
    else redirect_to '/'
    end
    rescue ActiveRecord::RecordInvalid
      render :action => 'signup'
  end
  
  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_to '/'
  end

  def chadmin
    @user = User.find_by_id(params[:id])
    if @user.admin?
      then @user.admin = false
    else @user.admin = true
    end
    @user.save!
    render :file => 'account/chadmin'
  end

  def chactive
    @user = User.find_by_id(params[:id])
    if @user.active?
      then @user.active = false
    else @user.active = true
    end
    @user.save!
    render :file => 'account/chactive'
  end
end
