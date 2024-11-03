# frozen_string_literal: true

class V1::OrderProductsController < ApplicationController
  # POST /order_products/import
  def import
    ReceivesOrderProductsToImportService.call(order_products_file_params.tempfile)

    render(json: import_response_body, status: :accepted)
  end

  private

  def order_products_file_params
    params.require(:file)
  end

  def import_response_body
    {
      data: nil,
      meta: {
        info: 'The import process will run in the background.'
      }
    }
  end
end
