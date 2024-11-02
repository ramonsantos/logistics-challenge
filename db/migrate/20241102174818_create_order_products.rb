# frozen_string_literal: true

class CreateOrderProducts < ActiveRecord::Migration[8.0]
  def change
    create_table(:order_products) do |t|
      t.integer(:product_id)
      t.decimal(:value)
      t.references(:order, null: false, foreign_key: { to_table: :orders, primary_key: :order_id })

      t.timestamps
    end
  end
end
