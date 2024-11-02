# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SingletonRedis, type: :singleton do
  describe '#connection' do
    it do
      expect(described_class.instance.connection).to be_a(Redis)
    end
  end
end
