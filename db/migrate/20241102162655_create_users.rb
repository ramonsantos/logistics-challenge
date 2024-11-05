# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table(:users) do |t|
      t.integer(:user_id)
      t.string(:name, limit: 45)

      t.timestamps
    end

    add_index(:users, [:user_id, :name], unique: true)
  end
end
