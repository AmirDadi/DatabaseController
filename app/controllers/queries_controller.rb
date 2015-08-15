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
    cmd = query_params[:query_cmd]
    begin 
      if !check_grants(cmd, Database.find(query_params[:database_id]))
        redirect_to queries_new_path, notice: "Access denied" and return
      end
    rescue Exception => e
      redirect_to queries_path, notice: e.message and return
    end

    if cmd.split[0].casecmp('select')==0
      @table = select_query(cmd, get_database)
      render :action => :select and return
    end
    db = get_database
    begin 
      @res = db.exec(query_params[:query_cmd])
      @query.save
      redirect_to queries_path, notice:  @res
    rescue PG::Error => e
      @res = e
      redirect_to(queries_path, notice: e) and return
    end
  end

 
  def select_star
    @table = select_query("SELECT * FROM #{params[:table]}", get_database)
  end


  def select

  end
  def index
    @queries = Query.all
  end

  def update
  end

  def rollback
  end



  private
  def query_params
    params.require(:query).permit(:query_cmd, :table, :database_id)
  end

  def set_query
  end
end