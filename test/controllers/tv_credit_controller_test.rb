require 'test_helper'

class TvCreditControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get tv_credit_index_url
    assert_response :success
  end

  test "should get create" do
    get tv_credit_create_url
    assert_response :success
  end

  test "should get update" do
    get tv_credit_update_url
    assert_response :success
  end

  test "should get edit" do
    get tv_credit_edit_url
    assert_response :success
  end

  test "should get delete" do
    get tv_credit_delete_url
    assert_response :success
  end

end
