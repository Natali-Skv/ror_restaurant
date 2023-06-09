class User < ApplicationRecord
  include ActiveModel::Validations
  validates :phone, presence: true, uniqueness: true,
                    numericality: { greater_than_or_equal_to: 79_000_000_000, less_than_or_equal_to: 79_999_999_999 }
  ERRORS = {
    INTERNAL_ERROR: 'internal error',
    NO_SUCH_DISH: 'no such dish in menu'
  }.freeze

  def clean_cart
    self.cart = '{}'
    save
  end

  def cart_empty?
    cart == '{}'
  end

  def remove_dish_from_cart(dish_id)
    cart = JSON.parse self.cart
    return [nil, ERRORS[:NO_SUCH_DISH]] unless cart[dish_id] || cart[dish_id].zero?

    cart[dish_id] -= 1
    cart.delete(dish_id) if cart[dish_id].zero?

    self.cart = cart.to_json
    save
    [User.full_cart_parsed(cart), nil]
  end

  def add_dish_to_cart(dish_id)
    cart = JSON.parse self.cart
    if cart[dish_id]
      cart[dish_id] += 1
    else
      return [nil, ERRORS[:NO_SUCH_DISH]] unless Dish.exists?(id: dish_id)

      cart[dish_id] = 1
    end
    self.cart = cart.to_json
    save
    [User.full_cart_parsed(cart), nil]
  end

  def full_cart
    cart = JSON.parse self.cart
    full_cart = { total: 0, dishes: [] }
    cart.each do |id, count|
      dish = Dish.find_by(id: id)
      full_cart[:dishes].append(ShortDish.new(dish.name, dish.price, dish.image_path, dish.calories, dish.weight,
                                              id, count))
      full_cart[:total] += dish.price * count
    end
    full_cart
  end

  class << self
    def full_cart_parsed(cart)
      full_cart = { total: 0, dishes: [] }
      cart.each do |id, count|
        dish = Dish.find_by(id: id)
        full_cart[:dishes].append(ShortDish.new(dish.name, dish.price, dish.image_path, dish.calories, dish.weight,
                                                id, count))
        full_cart[:total] += dish.price * count
      end
      full_cart
    end
  end

  ShortDish = Struct.new(:name, :price, :image_path, :calories, :weight, :id, :count)
end
