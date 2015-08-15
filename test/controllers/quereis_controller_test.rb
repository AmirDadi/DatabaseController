require 'test_helper'

class QuereisControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get update" do
    get :update
    assert_response :success
  end

  test "should get rollback" do
    get :rollback
    assert_response :success
  end

  test "should get query_params" do
    get :query_params
    assert_response :success
  end

  test "should get set_query" do
    get :set_query
    assert_response :success
  end

end
