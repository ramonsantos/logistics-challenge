# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:order_products).dependent(:destroy) }
  end

  describe '#update_total' do
    subject { create(:order, user: user) }

    let(:user) { create(:user) }

    before do
      create(:order_product, order: subject, value: 20.24)
      create(:order_product, order: subject, value: 199.13, product_id: 112)
    end

    it 'updates the total' do
      expect { subject.update_total }.to change { subject.reload.total }.from(nil).to(219.37)
    end
  end
end
