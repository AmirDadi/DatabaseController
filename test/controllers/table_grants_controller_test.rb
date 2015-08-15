require 'test_helper'

class TableGrantsControllerTest < ActionController::TestCase
  setup do
    @table_grant = table_grants(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:table_grants)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create table_grant" do
    assert_difference('TableGrant.count') do
      post :create, table_grant: { db_id: @table_grant.db_id, table: @table_grant.table, type: @table_grant.type, user_id: @table_grant.user_id }
    end

    assert_redirected_to table_grant_path(assigns(:table_grant))
  end

  test "should show table_grant" do
    get :show, id: @table_grant
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @table_grant
    assert_response :success
  end

  test "should update table_grant" do
    patch :update, id: @table_grant, table_grant: { db_id: @table_grant.db_id, table: @table_grant.table, type: @table_grant.type, user_id: @table_grant.user_id }
    assert_redirected_to table_grant_path(assigns(:table_grant))
  end

  test "should destroy table_grant" do
    assert_difference('TableGrant.count', -1) do
      delete :destroy, id: @table_grant
    end

    assert_redirected_to table_grants_path
  end
end
