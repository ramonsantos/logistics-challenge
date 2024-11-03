# frozen_string_literal: true

class EnqueueOrderProductsToImportJob
  include Sidekiq::Job

  sidekiq_options queue: 'enqueue_order_products_to_import', retry: 5

  def perform(file_content_key)
    # Do something later
  end
end
