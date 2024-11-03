# frozen_string_literal: true

require 'sidekiq/web'

Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: '_interslice_session'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  api_version(module: 'V1', default: true, header: { name: 'X-Version', value: '1' }) do
    resources :order_products, only: [] do
      post 'import', on: :collection
    end
  end
end
