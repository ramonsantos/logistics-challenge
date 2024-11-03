# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::OrderProductsController, type: :request do
  describe 'POST /order_products/import' do
    let(:file) { fixture_file_upload('spec/fixtures/data_0.txt') }
    let(:params) { { file: file } }
    let(:parser_response_body) { JSON.parse(response.body, symbolize_names: true) }

    context 'when successful' do
      let(:expected_body) do
        {
          data: nil,
          meta: {
            info: 'The import process will run in the background.'
          }
        }
      end

      before do
        allow(RedisService).to receive(:set).and_return('OK')
        allow(EnqueueOrderProductsToImportJob).to receive(:perform_later)

        post(import_order_products_path, params: params)
      end

      it 'returns status accepted' do
        expect(response).to have_http_status(:accepted)
        expect(parser_response_body).to eq(expected_body)
      end
    end

    context 'when error' do
      let(:expected_body) do
        {
          errors: [
            {
              title: 'Error importing order product.'
            }
          ]
        }
      end

      before do
        allow(RedisService).to receive(:set).and_raise(StandardError)

        post(import_order_products_path, params: params)
      end

      it 'returns status bad request' do
        expect(response).to have_http_status(:bad_request)
        expect(parser_response_body).to eq(expected_body)
      end
    end
  end
end
