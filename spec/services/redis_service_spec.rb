# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RedisService, type: :service do
  let(:key) { 'redis_key' }
  let(:value) { 'value' }
  let(:built_key) { "test_:#{key}" }

  after { SingletonRedis.instance.connection.del(built_key) }

  describe '.set' do
    it do
      expect(SingletonRedis.instance.connection.get(built_key)).to be_nil
      expect(described_class.set(key, value)).to eq('OK')
      expect(SingletonRedis.instance.connection.get(built_key)).to eq(value)
    end
  end

  describe '.get' do
    before { SingletonRedis.instance.connection.set(built_key, value) }

    it do
      expect(described_class.get(key)).to eq(value)
    end
  end

  describe '.del' do
    before { SingletonRedis.instance.connection.set(built_key, value) }

    it do
      expect do
        expect(described_class.del(key)).to eq(1)
      end.to change { SingletonRedis.instance.connection.get(built_key) }.from(value).to(nil)
    end
  end
end
