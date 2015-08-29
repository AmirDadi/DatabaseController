class QueriesController < ApplicationController
  helper :all
  include ApplicationHelper
  before_filter :authenticate_user! 
  def new
    @query = Query.new
    @databases = Database.all
    table_grant = TableGrant.new
    @databases = db_of_user(current_user.id, get_database)
    @tables = tables_of_user(current_user.id, get_database)
    if @tables_accessible.nil?
      @tables_accessible = []
    end
  end

  def create
    @query = Query.new(:query_cmd => query_params[:query_cmd], :database_id => query_params[:database_id], :user_id => current_user.id, :time => Time.now)
    @query.query_cmd = @query.query_cmd.gsub '"',"'"
    cmd = @query.query_cmd
 #   cmd = repair_alter(cmd)
    if !@query.valid?
      @databases = Database.all
      @table_grant = TableGrant.new
      @databases = db_of_user(current_user.id, get_database)
      @tables = tables_of_user(current_user.id, get_database)
     if @tables_accessible.nil?
        @tables_accessible = []
      end
      render 'new' and return
    end

    if cmd.tr('()','').split[0].casecmp('select')==0
      begin
        @table = select_query(cmd, get_database)
        render :action => :select and return
      rescue PG::Error =>e
        @databases = Database.all
        @table_grant = TableGrant.new
        @databases = db_of_user(current_user.id, get_database)
        @tables = tables_of_user(current_user.id, get_database)
        @query.errors.add(:query_cmd, e)
        if @tables_accessible.nil?
          @tables_accessible = []
        end
        render 'new' and return
      end        
    end
    begin

     
      @query.save
      @res = exec_query(cmd)
      redirect_to queries_path, notice:  @res
    rescue Exception => e
      @query.destroy
      @res = e
      redirect_to(queries_new_path, notice: e) and return
    end
  end

 
  def select_star
    @table = select_query("SELECT * FROM #{params[:table]}", get_database)
    render 'select'
  end


  def select
  end

  def index
    @queries = Query.all
  end

  def update
  end

  def roll_back
  end

  def show
  end

  private
  def query_params
    params.require(:query).permit(:query_cmd, :table, :database_id)
  end

  def set_query
  end
end