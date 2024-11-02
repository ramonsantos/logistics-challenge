# frozen_string_literal: true

class SingletonRedis
  include Singleton

  attr_accessor :connection

  def initialize
    @connection = Redis.new
  end
end
