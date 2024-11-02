# frozen_string_literal: true

class RedisService
  def initialize(key = nil, value = nil)
    @key = key
    @value = value
  end

  def self.set(key, value)
    new(key, value).set
  end

  def self.get(key)
    new(key).get
  end

  def self.del(key)
    new(key).del
  end

  def set
    connection.set(build_key(key), value)
  end

  def get
    connection.get(build_key(key))
  end

  def del
    connection.del(build_key(key))
  end

  private

  attr_reader :key
  attr_reader :value

  def connection
    SingletonRedis.instance.connection
  end

  def build_key(key)
    return key unless Rails.env.test?

    "test_:#{key}"
  end
end
