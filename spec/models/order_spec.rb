# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:order_products).dependent(:destroy) }
  end
end
