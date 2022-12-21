class Dish < ApplicationRecord
  belongs_to :categories

  def get_dishes; end
end
