# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table(:orders, id: false) do |t|
      t.primary_key(:order_id)
      t.date(:date)
      t.decimal(:total)
      t.references(:user, null: false, foreign_key: { to_table: :users, primary_key: :user_id })

      t.timestamps
    end

    add_index(:orders, :date)
  end
end
