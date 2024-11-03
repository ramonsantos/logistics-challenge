# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReceivesOrderProductsToImportService, type: :service do
  subject(:service) { described_class.new(file) }

  let(:file) { File.open('spec/fixtures/data_0.txt') }

  before do
    allow(SecureRandom).to receive(:uuid).and_return('20424b3d-f8ee-4d79-9920-e06328b07867')
    allow(RedisService).to receive(:set)
  end

  describe '#call' do
    context 'when the service is called successfully' do
      let(:expected_redis_key) { 'order_products_import:20424b3d-f8ee-4d79-9920-e06328b07867' }

      let(:expected_file_content) do
        <<~CONTENT
          0000000070                              Palmer Prosacco00000007530000000003     1836.7420210308
          0000000075                                  Bobbie Batz00000007980000000002     1578.5720211116
        CONTENT
      end

      before do
        allow(EnqueueOrderProductsToImportJob).to receive(:perform_async)

        subject.call
      end

      it 'stores the file content in Redis and enqueues the job' do
        expect(RedisService).to have_received(:set).with(expected_redis_key, expected_file_content).once
        expect(EnqueueOrderProductsToImportJob).to have_received(:perform_async).with(expected_redis_key).once
      end
    end

    context 'when an error occurs' do
      before do
        allow(RedisService).to receive(:set).and_raise(StandardError)
      end

      it 'raises an ApplicationError' do
        expect { service.call }.to raise_error(ApplicationError, 'Error importing order product.')
      end
    end
  end
end
