# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  before_filter :login_required, :except => :login
  helper :all # include all helpers, all the time
  protect_from_forgery :only => [:create, :update, :destroy]
  # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  layout 'menu.html.erb'

  def month_now
    ['Января','Февраля','Марта','Апреля','Мая','Июня','Июля','Августа','Сентября','Октября','Ноября','Декабря'][Time.now.mon]
  end

  def month_ru(nummm)
    ['Января','Февраля','Марта','Апреля','Мая','Июня','Июля','Августа','Сентября','Октября','Ноября','Декабря'][nummm]
  end


end
