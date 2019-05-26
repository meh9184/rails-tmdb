require 'test_helper'

class MovieControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get movie_index_url
    assert_response :success
  end

  test "should get create" do
    get movie_create_url
    assert_response :success
  end

  test "should get update" do
    get movie_update_url
    assert_response :success
  end

  test "should get edit" do
    get movie_edit_url
    assert_response :success
  end

  test "should get delete" do
    get movie_delete_url
    assert_response :success
  end

  test "should get credit" do
    get movie_credit_url
    assert_response :success
  end

end
