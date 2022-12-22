class Order < ApplicationRecord
  belongs_to :users, class_name: 'User', foreign_key: 'users_id'

  ERRORS = {
    INTERNAL_ERROR: 'internal error',
    EMPTY_CART: 'empty cart',
    EMPTY_ADDRESS: 'empty address provided'
  }.freeze

  class << self
    def create_order(current_user, address, comment)
      p current_user.id
      p '===12=='
      p current_user

      return ERRORS[:EMPTY_CART] if current_user.cart_empty?
      cart = current_user.full_cart
      return ERRORS[:EMPTY_ADDRESS] if address.nil? || address.empty?

      order = create(users_id: current_user.id, cart: cart.to_json, address: address, comment: comment)
      return ERRORS[:INTERNAL_ERROR] if order.nil?

      current_user.clean_cart
      nil
    end
  end
end
