# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::OrdersController, type: :request do
  describe 'GET /orders' do
    let(:user_1) { create(:user, user_id: 1) }
    let(:user_2) { create(:user, user_id: 2) }
    let(:user_3) { create(:user, user_id: 3) }
    let(:order_1) { create(:order, user: user_1, order_id: 1) }
    let(:order_2) { create(:order, user: user_2, order_id: 2) }
    let(:order_3) { create(:order, user: user_3, order_id: 3) }
    let(:order_4) { create(:order, user: user_1, order_id: 4) }
    let(:order_product_1) { create(:order_product, order: order_1) }
    let(:order_product_2) { create(:order_product, order: order_2) }
    let(:order_product_3) { create(:order_product, order: order_3) }
    let(:order_product_4) { create(:order_product, order: order_4) }
    let(:order_product_5) { create(:order_product, order: order_2) }
    let(:order_product_6) { create(:order_product, order: order_2) }
    let(:parser_response_body) { JSON.parse(response.body, symbolize_names: true) }

    let(:expected_body) do
      [
        {
          user_id: 1,
          name: 'Bobbie Batz',
          orders: [
            {
              order_id: 1,
              total: '',
              date: '2021-11-16',
              products: [
                { product_id: 111, value: '512.24' }
              ]
            },
            {
              order_id: 4,
              total: '',
              date: '2021-11-16',
              products: [
                { product_id: 111, value: '512.24' }
              ]
            }
          ]
        },
        {
          user_id: 2,
          name: 'Bobbie Batz',
          orders: [
            {
              order_id: 2,
              total: '',
              date: '2021-11-16',
              products: [
                { product_id: 111, value: '512.24' },
                { product_id: 111, value: '512.24' },
                { product_id: 111, value: '512.24' }
              ]
            }
          ]
        },
        {
          user_id: 3,
          name: 'Bobbie Batz',
          orders: [
            {
              order_id: 3,
              total: '',
              date: '2021-11-16',
              products: [
                { product_id: 111, value: '512.24' }
              ]
            }
          ]
        }
      ]
    end

    before do
      order_product_1
      order_product_2
      order_product_3
      order_product_4
      order_product_5
      order_product_6

      get(orders_path)
    end

    it do
      expect(response).to have_http_status(:ok)
      expect(parser_response_body).to eq(expected_body)
    end
  end
end
