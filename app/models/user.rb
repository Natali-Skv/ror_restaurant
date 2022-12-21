class User < ApplicationRecord
  ERRORS = {
    INTERNAL_ERROR: 'internal error',
    NO_SUCH_DISH: 'no such dish in menu'
  }.freeze

  def add_dish_to_cart(dish_id)
    cart = JSON.parse self.cart
    p cart
    p cart[dish_id]
    if cart[dish_id]
      cart[dish_id] += 1
      p cart
    else
      return [nil, ERRORS[:NO_SUCH_DISH]] unless Dish.exists?(id: dish_id)

      cart[dish_id] = 1
      p cart
    end
    self.cart = cart.to_json
    save
    [full_cart_parsed(cart), nil]
  end

  def full_cart_parsed(cart)
    full_cart = { total: 0, dishes: [] }
    cart.each do |id, count|
      dish = Dish.find_by(id: id)
      full_cart[:dishes].append(ShortDish.new(dish.name, dish.price, dish.image_path, dish.calories, dish.weight,
                                              id, count))
      full_cart[:total] += dish.price * count
    end
    p full_cart
    full_cart
    # проитерироваться по корзине, собрать массив блюд, посчитать общую стоимость
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
    p full_cart
    full_cart
    # проитерироваться по корзине, собрать массив блюд, посчитать общую стоимость
  end

  ShortDish = Struct.new(:name, :price, :image_path, :calories, :weight, :id, :count)
end
