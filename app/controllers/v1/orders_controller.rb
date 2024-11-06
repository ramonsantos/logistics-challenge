# frozen_string_literal: true

class V1::OrdersController < ApplicationController
  # GET /orders
  def index
    render(json: ListOrdersService.call({}), status: :ok)
  end
end
