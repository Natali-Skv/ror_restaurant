# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'should create user' do
    expect(User.create(phone: 79_015_020_456).valid?).to be true
  end

  it 'should not create user with dublicated phone' do
    phone = 79_015_020_456
    expect(User.create(phone: phone).nil?).to be false
    expect(User.create(phone: phone).valid?).to be false
  end

  it 'should create user with default empty cart' do
    user = User.create(phone: 79_015_020_456)
    expect(user.nil?).to be false
    expect user.cart == '{}'
  end

  it 'should not create user with empty phone' do
    expect(User.create.valid?).to be false
  end

  it 'should not create user with too small phone' do
    expect(User.create(phone: 123).valid?).to be false
  end

  it 'should not create user with too long phone' do
    expect(User.create(phone: 790_150_204_566).valid?).to be false
  end

  it 'should not create user with phone not starting with 79' do
    expect(User.create(phone: 76_015_020_456).valid?).to be false
  end

  it 'should clean cart' do
    user = User.create(phone: 79_015_020_456, cart: '{"619":1,"626":1}')
    expect(user).not_to be_nil
    expect(user.cart_empty?).to be false
    user.clean_cart
    expect(user.cart_empty?).to be true
  end

  it 'should parse full user cart' do
    category, dish = create_category_and_dish
    expect(category.valid?).to be true
    expect(dish.valid?).to be true

    cart = "{\"#{dish.id}\": 1}"
    user = User.create(phone: 79_015_020_456, cart: cart)
    expect(user.valid?).to be true

    expect(user.full_cart).to eq({
                                   dishes: [User::ShortDish.new(dish.name, dish.price, dish.image_path, dish.calories,
                                                                dish.weight, dish.id.to_s, 1)], total: 50
                                 })
  end

  it 'should parse full cart' do
    category, dish = create_category_and_dish
    expect(category.valid?).to be true
    expect(dish.valid?).to be true

    cart = JSON.parse "{\"#{dish.id}\": 1}"
    expect(User.full_cart_parsed(cart)).to eq({
                                                dishes: [User::ShortDish.new(dish.name, dish.price, dish.image_path, dish.calories,
                                                                             dish.weight, dish.id.to_s, 1)], total: 50
                                              })
  end

  it 'should add dish to user cart' do
    category, dish = create_category_and_dish
    expect(category.valid?).to be true
    expect(dish.valid?).to be true
    user = User.create(phone: 79_015_020_456, cart: '{}')
    expect(user.valid?).to be true

    expect(user.cart_empty?).to be true

    user.add_dish_to_cart(dish.id.to_s)

    expect(user.cart_empty?).to be false
    expect(user.cart).to eq("{\"#{dish.id}\":1}")
  end

  it 'should increase the amount of existing dish in cart' do
    category, dish = create_category_and_dish
    expect(category.valid?).to be true
    expect(dish.valid?).to be true
    user = User.create(phone: 79_015_020_456, cart: "{\"#{dish.id}\":1}")
    expect(user.valid?).to be true
    expect(user.add_dish_to_cart(dish.id.to_s)).to eq([{
                                                        dishes: [User::ShortDish.new(dish.name, dish.price, dish.image_path, dish.calories,
                                                                                     dish.weight, dish.id.to_s, 2)], total: 100
                                                      }, nil])

    expect(user.cart_empty?).to be false
    expect(user.cart).to eq("{\"#{dish.id}\":2}")
  end

  it 'should remove dish from user cart' do
    category, dish = create_category_and_dish
    expect(category.valid?).to be true
    expect(dish.valid?).to be true
    user = User.create(phone: 79_015_020_456, cart: "{\"#{dish.id}\":1}")
    expect(user.valid?).to be true

    expect(user.cart_empty?).to be false

    expect(user.remove_dish_from_cart(dish.id.to_s)).to eq([{ dishes: [], total: 0 }, nil])
    expect(user.cart_empty?).to be true
  end

  it 'should reduce the amount of existing dish in cart' do
    category, dish = create_category_and_dish
    expect(category.valid?).to be true
    expect(dish.valid?).to be true
    user = User.create(phone: 79_015_020_456, cart: "{\"#{dish.id}\":2}")
    expect(user.valid?).to be true

    expect(user.remove_dish_from_cart(dish.id.to_s)).to eq([{
                                                             dishes: [User::ShortDish.new(dish.name, dish.price, dish.image_path, dish.calories,
                                                                                          dish.weight, dish.id.to_s, 1)], total: 50
                                                           }, nil])
    expect(user.cart_empty?).to be false
    expect(user.cart).to eq("{\"#{dish.id}\":1}")
  end

  it 'should not add inexisting dish to cart' do
    user = User.create(phone: 79_015_020_456, cart: '{}')
    expect(user.valid?).to be true
    inexisting_dish_id = 1
    expect(user.add_dish_to_cart(inexisting_dish_id)).to eq([nil, User::ERRORS[:NO_SUCH_DISH]])

    expect(user.cart_empty?).to be true
  end

  def create_category_and_dish
    category = Category.create(name: 'category_name', slug: 'category_name')
    dish = Dish.create(categories_id: category.id, name: 'Имбирь', description: '18 ккал/100 г',
                       image_path: '330801255.webp', calories: 18, weight: 30, price: 50)
    [category, dish]
  end
end
