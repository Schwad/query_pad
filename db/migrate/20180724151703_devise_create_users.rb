# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email
      t.string :provider
      t.string :uid
      t.string :name
      t.string :remember_token
      t.datetime :remember_created_at
      t.timestamps null: false
    end

    add_index :users, :email, unique: true
    add_index :users, [:uid, :provider], unique: true
  end
end
