# frozen_string_literal: true

class UpdateTotalOfOrderJob
  include Sidekiq::Job

  sidekiq_options queue: 'update_total_of_order', retry: 4

  def perform(id)
    Order.find(id).update_total
  end
end
