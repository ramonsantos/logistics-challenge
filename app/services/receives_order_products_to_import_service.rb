# frozen_string_literal: true

class ReceivesOrderProductsToImportService < ApplicationService
  def initialize(file)
    @file = file
  end

  def call
    RedisService.set(file_redis_key, file_content)
    EnqueueOrderProductsToImportJob.perform_async(file_redis_key)
  rescue StandardError => _error
    raise(ApplicationError, 'Error importing order product.')
  end

  private

  attr_reader :file

  def file_content
    @file_content ||= file.read
  end

  def file_redis_key
    @file_redis_key ||= "order_products_import:#{SecureRandom.uuid}"
  end
end
