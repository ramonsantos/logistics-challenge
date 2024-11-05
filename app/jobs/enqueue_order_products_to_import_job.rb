# frozen_string_literal: true

class EnqueueOrderProductsToImportJob
  include Sidekiq::Job

  sidekiq_options queue: 'enqueue_order_products_to_import', retry: 5

  def perform(file_content_key)
    lines = RedisService.get(file_content_key).lines.zip

    ImportOrderProductJob.perform_bulk(lines, batch_size: 1000)

    RedisService.del(file_content_key)
  end
end
