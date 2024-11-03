# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    order_id { 798 }
    user_id { 75 }
    date { '2021-11-16' }
  end
end
