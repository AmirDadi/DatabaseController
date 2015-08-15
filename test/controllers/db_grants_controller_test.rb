require 'test_helper'

class DbGrantsControllerTest < ActionController::TestCase
  setup do
    @db_grant = db_grants(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:db_grants)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create db_grant" do
    assert_difference('DbGrant.count') do
      post :create, db_grant: { db: @db_grant.db, type: @db_grant.type, user_id: @db_grant.user_id }
    end

    assert_redirected_to db_grant_path(assigns(:db_grant))
  end

  test "should show db_grant" do
    get :show, id: @db_grant
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @db_grant
    assert_response :success
  end

  test "should update db_grant" do
    patch :update, id: @db_grant, db_grant: { db: @db_grant.db, type: @db_grant.type, user_id: @db_grant.user_id }
    assert_redirected_to db_grant_path(assigns(:db_grant))
  end

  test "should destroy db_grant" do
    assert_difference('DbGrant.count', -1) do
      delete :destroy, id: @db_grant
    end

    assert_redirected_to db_grants_path
  end
end
