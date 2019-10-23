# frozen_string_literal: true

class CreateRelays < ActiveRecord::Migration[5.2]
  def change
    create_table :relays do |t|
      t.references :device, foreign_key: true
      t.references :sensor, foreign_key: true
      t.string :name
      t.integer :order
      t.string :conf_name
      t.boolean :value
      t.string :icon
      t.integer :state, default: 0
    end
  end
end
