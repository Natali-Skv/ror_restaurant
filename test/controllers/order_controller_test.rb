require "test_helper"

class OrderControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get order_create_url
    assert_response :success
  end

  test "should get show_create" do
    get order_show_create_url
    assert_response :success
  end

  test "should get list" do
    get order_list_url
    assert_response :success
  end
end
