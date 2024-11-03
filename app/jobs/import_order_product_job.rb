# frozen_string_literal: true

class ImportOrderProductJob
  include Sidekiq::Job

  sidekiq_options queue: 'import_order_product', retry: 6

  def perform(order_product_line)
    ImportOrderProductService.new(order_product_line).call
  end
end
