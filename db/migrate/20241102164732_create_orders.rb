# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table(:orders) do |t|
      t.integer(:order_id)
      t.date(:date)
      t.decimal(:total)
      t.references(:user, null: false, foreign_key: true)

      t.timestamps
    end

    add_index(:orders, :date)
    add_index(:orders, :order_id)
    add_index(:orders, [:order_id, :date], unique: true)
  end
end
