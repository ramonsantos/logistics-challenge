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
    return if User.exists?(user_id: user_attributes[:user_id])

    User.create!(user_attributes)
  end

  def import_order
    return if Order.exists?(order_id: order_attributes[:order_id])

    Order.create!(order_attributes)
  end

  def import_order_product
    OrderProduct.create!(order_product_attributes)
  end

  def user_attributes
    extracted_attributes[:user]
  end

  def order_attributes
    extracted_attributes[:order]
  end

  def order_product_attributes
    extracted_attributes[:order_product]
  end

  def extracted_attributes
    @extracted_attributes ||= ExtractsAttributesFromLineService.call(line)
  end
end
