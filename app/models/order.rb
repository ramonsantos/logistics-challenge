# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  has_many :order_products, dependent: :destroy

  def update_total
    with_lock { update!(total: order_products.sum(:value)) }
  end
end
