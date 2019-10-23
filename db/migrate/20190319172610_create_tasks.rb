# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.references :relay, foreign_key: true
      t.references :sensor, foreign_key: true
      t.decimal :min, precision: 10, scale: 2
      t.decimal :max, precision: 10, scale: 2
    end
  end
end
