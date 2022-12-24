# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  it 'should create order' do
    category, dish = create_category_and_dish
    expect(category.valid?).to be true
    expect(dish.valid?).to be true
    cart = "{\"#{dish.id}\":1}"
    user = User.create(phone: 79_015_020_456, cart: cart)
    expect(user.valid?).to be true

    address = 'Москва, Измайловская 3'
    comment = 'comment'
    full_cart = user.full_cart
    expect(Order.create_order(user, address, comment)).to be_nil
    expect(Order.exists?(users_id: user.id, address: address, comment: comment, cart: full_cart.to_json))
    expect(user.cart_empty?).to be true
  end

  it 'should not create order with no address' do
    category, dish = create_category_and_dish
    expect(category.valid?).to be true
    expect(dish.valid?).to be true
    cart = "{\"#{dish.id}\":1}"
    user = User.create(phone: 79_015_020_456, cart: cart)
    expect(user.valid?).to be true

    comment = 'comment'
    expect(Order.create_order(user, '', comment)).to eq(Order::ERRORS[:EMPTY_ADDRESS])
  end

  it 'should not create order with empty cart' do
    category, dish = create_category_and_dish
    expect(category.valid?).to be true
    expect(dish.valid?).to be true
    user = User.create(phone: 79_015_020_456, cart: '{}')
    expect(user.valid?).to be true

    address = 'Москва, Измайловская 3'
    comment = 'comment'
    expect(Order.create_order(user, address, comment)).to eq(Order::ERRORS[:EMPTY_CART])
  end

  def create_category_and_dish
    category = Category.create(name: 'category_name', slug: 'category_name')
    dish = Dish.create(categories_id: category.id, name: 'Имбирь', description: '18 ккал/100 г',
                       image_path: '330801255.webp', calories: 18, weight: 30, price: 50)
    [category, dish]
  end
end
