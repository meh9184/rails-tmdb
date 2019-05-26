require 'test_helper'

class MovieCreditControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get movie_credit_index_url
    assert_response :success
  end

  test "should get create" do
    get movie_credit_create_url
    assert_response :success
  end

  test "should get update" do
    get movie_credit_update_url
    assert_response :success
  end

  test "should get edit" do
    get movie_credit_edit_url
    assert_response :success
  end

  test "should get delete" do
    get movie_credit_delete_url
    assert_response :success
  end

end
