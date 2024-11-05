# frozen_string_literal: true

class V1::OrdersController < ApplicationController
  # GET /orders
  def index
    orders = Order.includes(:order_products, :user).order(:order_id).limit(20)

    result = {}

    orders.each do |order|
      user = order.user

      result[user.id] = { user_id: user.id, name: user.name, orders: [] } if result[user.id].nil?

      result[user.id][:orders] << {
        order_id: order.id,
        total: order.total.to_s,
        date: order.date,

        products: order.order_products.map do |order_product|
          {
            product_id: order_product.product_id,
            value: order_product.value.to_s
          }
        end
      }
    end

    render(json: result.values)
  end
end
