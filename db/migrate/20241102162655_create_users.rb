# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table(:users, id: false) do |t|
      t.primary_key(:user_id)
      t.string(:name)

      t.timestamps
    end
  end
end
