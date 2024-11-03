# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImportOrderProductJob, type: :job do
  subject { described_class.new }

  let(:order_product_line) { '0000000075                                  Bobbie Batz00000007980000000002     1578.5720211116' }

  before do
    create(:user)
  end

  describe '#perform' do
    let(:before_count) { { users: 1, orders: 0, order_products: 0 } }
    let(:after_count) { { users: 1, orders: 1, order_products: 1 } }

    let(:model_count_proc) do
      proc do
        {
          users: User.count,
          orders: Order.count,
          order_products: OrderProduct.count
        }
      end
    end

    it 'creates order and order product' do
      expect do
        subject.perform(order_product_line)
      end.to change(model_count_proc, :call).from(before_count).to(after_count)
    end
  end
end
