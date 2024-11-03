# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImportOrderProductService, type: :service do
  subject { described_class.new(line) }

  let(:line) { '0000000075                                  Bobbie Batz00000007980000000002     1578.5720211116' }

  describe '#call' do
    let(:model_count_proc) do
      proc do
        {
          users: User.count,
          orders: Order.count,
          order_products: OrderProduct.count
        }
      end
    end

    context 'when successful' do
      let(:after_count) { { users: 1, orders: 1, order_products: 1 } }

      context 'when create user, order, and order_product' do
        let(:before_count) { { users: 0, orders: 0, order_products: 0 } }

        it { expect { subject.call }.to change(model_count_proc, :call).from(before_count).to(after_count) }
      end

      context 'when user already exists' do
        let(:before_count) { { users: 1, orders: 0, order_products: 0 } }

        before { create(:user) }

        it { expect { subject.call }.to change(model_count_proc, :call).from(before_count).to(after_count) }
      end

      context 'when order already exists' do
        let(:before_count) { { users: 1, orders: 1, order_products: 0 } }

        before do
          create(:user)
          create(:order)
        end

        it { expect { subject.call }.to change(model_count_proc, :call).from(before_count).to(after_count) }
      end
    end

    context 'when error' do
      before do
        allow(OrderProduct).to receive(:create!).and_raise(ActiveRecord::RecordInvalid)

        create(:user)
      end

      it do
        expect { subject.call }.to raise_error(ActiveRecord::RecordInvalid)

        expect(model_count_proc.call).to eq({ users: 1, orders: 0, order_products: 0 })
      end
    end
  end
end
