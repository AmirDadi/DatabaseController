class HomeController < ApplicationController
  before_filter :authenticate_user!
  def index
  	if current_user.admin?
  		redirect_to '/table_grants'
    else
    	redirect_to '/queries/new'
    end
  end
end
