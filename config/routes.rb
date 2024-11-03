# frozen_string_literal: true

Rails.application.routes.draw do
  api_version(module: 'V1', default: true, header: { name: 'X-Version', value: '1' }) do
    resources :order_products, only: [] do
      post 'import', on: :collection
    end
  end
end
