# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExtractsAttributesFromLineService do
  describe '#call' do
    subject(:service) { described_class.new(line) }

    let(:line) { '0000000070                              Palmer Prosacco00000007530000000003     1836.7420210308' }

    let(:expected_result) do
      {
        user: {
          user_id: 70,
          name: 'Palmer Prosacco'
        },
        order: {
          order_id: 753,
          user_id: 70,
          date: Date.parse('2021-03-08')
        },
        order_product: {
          order_id: 753,
          product_id: 3,
          value: 1836.74
        }
      }
    end

    it { expect(service.call).to eq(expected_result) }
  end
end
