# frozen_string_literal: true

class ListOrdersService < ApplicationService
  def initialize(params)
    @params = params
  end

  def call
    {}.tap do |result|
      orders.each do |order|
        user = order.user

        result[user.id] = { user_id: user.user_id, name: user.name, orders: [] } if result[user.id].nil?

        result[user.id][:orders] << build_order(order)
      end
    end.values
  end

  private

  attr_reader :params

  def orders
    @orders ||= fetch_orders
  end

  def fetch_orders
    orders = Order.includes(:order_products, :user).order(:order_id).limit(20)
    orders = orders.where(orders: { date: (params[:start_date]).. }) if params[:start_date].present?
    orders = orders.where(orders: { date: ..(params[:end_date]) }) if params[:end_date].present?
    orders = orders.where(order_id: params[:order_id]) if params[:order_id].present?

    orders
  end

  def build_order(order)
    {
      order_id: order.order_id,
      total: order.total.to_s,
      date: order.date.to_s,

      products: order.order_products.map { |order_product| build_order_product(order_product) }

    }
  end

  def build_order_product(order_product)
    {
      product_id: order_product.product_id,
      value: order_product.value.to_s
    }
  end
end
