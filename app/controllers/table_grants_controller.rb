class TableGrantsController < AdminController

  before_action :set_table_grant, only: [:show, :edit, :update, :destroy]

  respond_to :html

  helper :all
  include ApplicationHelper

  def index
    @table_grants = TableGrant.all
    @table_grant = TableGrant.new
    @databases = Database.all
    @tables = get_all_tables
    @users = User.all
    @user = User.new
    respond_with(@table_grants)
  end

  def show
    respond_with(@table_grant)
  end

  def new
    @table_grant = TableGrant.new
    respond_with(@table_grant)
  end

  def edit
  end

  def create
    @table_grant = TableGrant.new(table_grant_params)
    if  @table_grant.save
      redirect_to table_grants_path
    else
      @table_grants = TableGrant.all
      @tables = get_table_names
      @users = User.all
      render :action => :index
    end
  end

  def update
    @table_grant.update(table_grant_params)
    respond_with(@table_grant)
  end

  def destroy
    @table_grant.destroy
    respond_with(@table_grant)
  end





  private
    

    def set_table_grant
      @table_grant = TableGrant.find(params[:id])
    end

    def table_grant_params
      params.require(:table_grant).permit(:user_id, :db_id, :table, :access_type)
    end
end
