# frozen_string_literal: true

class ImportOrderProductJob
  include Sidekiq::Job

  sidekiq_options queue: 'import_order_product', retry: 6

  def perform(*args)
    # Do something later
  end
end
