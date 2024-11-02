# frozen_string_literal: true

class EnqueueOrderProductsToImportJob < ApplicationJob
  queue_as :default

  def perform(file_content_key)
    # Do something later
  end
end
