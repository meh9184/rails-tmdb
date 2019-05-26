require 'test_helper'

class TvControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get tv_index_url
    assert_response :success
  end

  test "should get create" do
    get tv_create_url
    assert_response :success
  end

  test "should get update" do
    get tv_update_url
    assert_response :success
  end

  test "should get edit" do
    get tv_edit_url
    assert_response :success
  end

  test "should get delete" do
    get tv_delete_url
    assert_response :success
  end

  test "should get credit" do
    get tv_credit_url
    assert_response :success
  end

end
