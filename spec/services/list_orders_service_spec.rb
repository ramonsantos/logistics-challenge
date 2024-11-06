# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ListOrdersService, type: :service do
  subject { described_class.new(params) }

  let(:user_1) { create(:user, user_id: 1) }
  let(:user_2) { create(:user, user_id: 2) }
  let(:user_3) { create(:user, user_id: 3) }
  let(:user_4) { create(:user, user_id: 1, name: 'Tashia Schamberger') }
  let(:order_1) { create(:order, user: user_1, order_id: 1, date: '2021-11-17') }
  let(:order_2) { create(:order, user: user_2, order_id: 2) }
  let(:order_3) { create(:order, user: user_3, order_id: 3, date: '2021-11-20') }
  let(:order_4) { create(:order, user: user_1, order_id: 4) }
  let(:order_5) { create(:order, user: user_4, order_id: 1, date: '2021-11-23') }
  let(:order_product_1) { create(:order_product, order: order_1) }
  let(:order_product_2) { create(:order_product, order: order_2) }
  let(:order_product_3) { create(:order_product, order: order_3) }
  let(:order_product_4) { create(:order_product, order: order_4) }
  let(:order_product_5) { create(:order_product, order: order_2) }
  let(:order_product_6) { create(:order_product, order: order_2) }
  let(:order_product_7) { create(:order_product, order: order_5) }

  let(:params) { {} }

  before do
    order_product_1
    order_product_2
    order_product_3
    order_product_4
    order_product_5
    order_product_6
    order_product_7
  end

  describe '#call' do
    context 'without params' do
      let(:expected_body) do
        [
          {
            user_id: 1,
            name: 'Bobbie Batz',
            orders: [
              {
                order_id: 1,
                total: '',
                date: '2021-11-17',
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
            user_id: 1,
            name: 'Tashia Schamberger',
            orders: [
              {
                order_id: 1,
                total: '',
                date: '2021-11-23',
                products: [
                  {
                    product_id: 111,
                    value: '512.24'
                  }
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
                date: '2021-11-20',
                products: [
                  { product_id: 111, value: '512.24' }
                ]
              }
            ]
          }
        ]
      end

      it 'returns the expected body' do
        expect(subject.call).to eq(expected_body)
      end
    end

    context 'with filter by date' do
      let(:params) { { start_date: '2021-11-17', end_date: '2021-11-23' } }

      let(:expected_body) do
        [
          {
            user_id: 1,
            name: 'Bobbie Batz',
            orders: [
              {
                order_id: 1,
                total: '',
                date: '2021-11-17',
                products: [
                  { product_id: 111, value: '512.24' }
                ]
              }

            ]
          },
          {
            user_id: 1,
            name: 'Tashia Schamberger',
            orders: [
              {
                order_id: 1,
                total: '',
                date: '2021-11-23',
                products: [
                  {
                    product_id: 111,
                    value: '512.24'
                  }
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
                date: '2021-11-20',
                products: [
                  { product_id: 111, value: '512.24' }
                ]
              }
            ]
          }
        ]
      end

      it 'returns the expected body' do
        expect(subject.call).to eq(expected_body)
      end
    end

    context 'with filter by order_id' do
      let(:params) { { order_id: '1' } }

      let(:expected_body) do
        [
          {
            user_id: 1,
            name: 'Bobbie Batz',
            orders: [
              {
                order_id: 1,
                total: '',
                date: '2021-11-17',
                products: [
                  { product_id: 111, value: '512.24' }
                ]
              }
            ]
          },
          {
            user_id: 1,
            name: 'Tashia Schamberger',
            orders: [
              {
                order_id: 1,
                total: '',
                date: '2021-11-23',
                products: [
                  {
                    product_id: 111,
                    value: '512.24'
                  }
                ]
              }
            ]
          }
        ]
      end

      it 'returns the expected body' do
        expect(subject.call).to eq(expected_body)
      end
    end

    context 'with filter by date and order_id' do
      let(:params) { { start_date: '2021-11-17', end_date: '2021-11-23', order_id: 3 } }

      let(:expected_body) do
        [
          {
            user_id: 3,
            name: 'Bobbie Batz',
            orders: [
              {
                order_id: 3,
                total: '',
                date: '2021-11-20',
                products: [
                  { product_id: 111, value: '512.24' }
                ]
              }
            ]
          }
        ]
      end

      it 'returns the expected body' do
        expect(subject.call).to eq(expected_body)
      end
    end

    context 'with pagination' do
      let(:params) { { page: 2, per_page: 3 } }

      let(:expected_body) do
        [
          {
            user_id: 3,
            name: 'Bobbie Batz',
            orders: [
              {
                order_id: 3,
                total: '',
                date: '2021-11-20',
                products: [
                  { product_id: 111, value: '512.24' }
                ]
              }
            ]
          },
          {
            user_id: 1,
            name: 'Bobbie Batz',
            orders: [
              {
                order_id: 4,
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

      it 'returns the expected body' do
        expect(subject.call).to eq(expected_body)
      end
    end
  end
end
