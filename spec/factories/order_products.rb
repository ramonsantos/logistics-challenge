# frozen_string_literal: true

FactoryBot.define do
  factory :order_product do
    product_id { 111 }
    value { 512.24 }
  end
end
