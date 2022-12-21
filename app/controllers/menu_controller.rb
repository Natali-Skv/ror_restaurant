class MenuController < ApplicationController
  def get_menu
    # @categories = Category.all.map(&:name)
    @categories = Category.all
    @dishes = Dish.all.group_by(&:categories_id)
    p @dishes[1]
    # @categories = Category.get_categories
    # @result
    # достать из бд все блюда
    # отформатировать
  end

  def add_dish
    # если неавторизован -- отрисовать модалку логина
    redirect_to session_login_url
  end

  def remove_dish; end

  def get_cart; end
end
