# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EnqueueOrderProductsToImportJob, type: :job do
  describe '#perform' do
    subject(:job) { described_class.new }

    let(:file_content_key) { 'order_products_import:20424b3d-f8ee-4d79-9920-e06328b07867' }

    let(:file_content) do
      <<~CONTENT
        0000000070                              Palmer Prosacco00000007530000000003     1836.7420210308
        0000000075                                  Bobbie Batz00000007980000000002     1578.5720211116
        0000000049                               Ken Wintheiser00000005230000000003      586.7420210903
      CONTENT
    end

    let(:expected_bulk_args) do
      [
        ["0000000070                              Palmer Prosacco00000007530000000003     1836.7420210308\n"],
        ["0000000075                                  Bobbie Batz00000007980000000002     1578.5720211116\n"],
        ["0000000049                               Ken Wintheiser00000005230000000003      586.7420210903\n"]
      ]
    end

    before do
      allow(RedisService).to receive(:get).with(file_content_key).and_return(file_content)
      allow(ImportOrderProductJob).to receive(:perform_bulk)

      job.perform(file_content_key)
    end

    it 'enqueues ImportOrderProductJob with the lines' do
      expect(ImportOrderProductJob).to have_received(:perform_bulk).with(expected_bulk_args, batch_size: 1000)
    end
  end
end
