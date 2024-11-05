# frozen_string_literal: true

class ImportOrderProductService < ApplicationService
  def initialize(line)
    @line = line
  end

  def call
    ActiveRecord::Base.transaction do
      import_user
      import_order
      import_order_product
    end

    UpdateTotalOfOrderJob.perform_async(order_attributes[:order_id])
  end

  private

  attr_reader :line

  def import_user
    return if user

    @user = User.create!(user_attributes)
  end

  def import_order
    return if order

    @order = Order.create!(order_attributes)
  end

  def import_order_product
    OrderProduct.create!(order_product_attributes)
  end

  def user_attributes
    extracted_attributes[:user]
  end

  def order_attributes
    extracted_attributes[:order].tap do |order_attributes|
      order_attributes[:user_id] = user.id
    end
  end

  def order_product_attributes
    extracted_attributes[:order_product].tap do |order_product_attributes|
      order_product_attributes[:order_id] = order.id
    end
  end

  def extracted_attributes
    @extracted_attributes ||= ExtractsAttributesFromLineService.call(line)
  end

  def user
    @user ||= User.find_by(user_id: user_attributes[:user_id], name: user_attributes[:name])
  end

  def order
    @order ||= Order.find_by(order_id: order_attributes[:order_id], date: order_attributes[:date])
  end
end
