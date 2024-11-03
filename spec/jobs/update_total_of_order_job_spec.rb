# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateTotalOfOrderJob, type: :job do
  let(:order) { create(:order) }

  describe '#perform' do
    subject { described_class.new }

    let(:user) { create(:user) }
    let(:order) { create(:order, user: user, total: 512.24) }

    before do
      order
      create(:order_product, order: order, value: 512.24)
      create(:order_product, order: order, value: 512.24, product_id: 112)
    end

    it 'updates the total' do
      expect { subject.perform(order.id) }.to change { order.reload.total }.from(512.24).to(1024.48)
    end
  end
end
