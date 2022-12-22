class OrderController < ApplicationController
  before_action :require_login, only: %i[show_create create]

  def create
    p "\n!!!!\n"
    p current_user
    p signed_in?
    # записать в бд
    # редирект на страницу истории заказов
    comment = params[:comment]
    comment = '' if comment.nil?
    model_error = Order.create_order(current_user, params[:address], comment)
    p params[:address]
    p comment
    case model_error
    when nil
      redirect_to root_url
    when Order::ERRORS[:EMPTY_ADDRESS]
      @error = 'Необходимо указать адрес'
      render :show_create
    when Order::ERRORS[:EMPTY_CART]
      @error = 'Чтобы оформить заказ, добавьте товары в корзину'
      render :show_create
    else
      redirect_to500
    end
  end

  def show_create; end

  def list; end
end
