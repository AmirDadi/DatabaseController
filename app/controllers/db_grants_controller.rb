class DbGrantsController < ApplicationController
  before_action :set_db_grant, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @db_grants = DbGrant.all
    respond_with(@db_grants)
  end

  def show
    respond_with(@db_grant)
  end

  def new
    @db_grant = DbGrant.new
    respond_with(@db_grant)
  end

  def edit
  end

  def create
    @db_grant = DbGrant.new(db_grant_params)
    @db_grant.save
    respond_with(@db_grant)
  end

  def update
    @db_grant.update(db_grant_params)
    respond_with(@db_grant)
  end

  def destroy
    @db_grant.destroy
    respond_with(@db_grant)
  end

  private
    def set_db_grant
      @db_grant = DbGrant.find(params[:id])
    end

    def db_grant_params
      params.require(:db_grant).permit(:user_id, :db, :access_type)
    end
end
