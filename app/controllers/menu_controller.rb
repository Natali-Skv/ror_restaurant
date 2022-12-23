class MenuController < ApplicationController
  before_action :require_login, only: %i[add_dish remove_dish]

  def menu
    @categories = Category.all
    @dishes = Dish.all.group_by(&:categories_id)
  end

  def add_dish
    full_cart, model_error = current_user.add_dish_to_cart(params[:id])
    render json: full_cart.to_json unless model_error
  end

  def remove_dish
    full_cart, model_error = current_user.remove_dish_from_cart(params[:id])
    render json: full_cart.to_json unless model_error
  end

  def cart
    return render json: {} unless signed_in?

    render json: current_user.full_cart.to_json
  end
end
