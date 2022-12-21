require "test_helper"

class MenuControllerTest < ActionDispatch::IntegrationTest
  test "should get menu" do
    get menu_menu_url
    assert_response :success
  end

  test "should get add_dish" do
    get menu_add_dish_url
    assert_response :success
  end

  test "should get remove_dish" do
    get menu_remove_dish_url
    assert_response :success
  end

  test "should get cart" do
    get menu_cart_url
    assert_response :success
  end
end
