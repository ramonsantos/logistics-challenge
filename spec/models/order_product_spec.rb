# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrderProduct, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:order) }
  end
end
