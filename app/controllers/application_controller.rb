# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ::ApplicationError, with: :handle_application_error

  protected

  def handle_application_error(error)
    render(json: application_error_response_body(error), status: :bad_request)
  end

  private

  def application_error_response_body(error)
    {
      errors: [
        {
          title: error.message
        }
      ]
    }
  end
end
