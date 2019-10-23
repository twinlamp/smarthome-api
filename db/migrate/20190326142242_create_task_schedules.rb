# frozen_string_literal: true

class CreateTaskSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :task_schedules do |t|
      t.references :task, foreign_key: true
      t.datetime :start
      t.datetime :stop
      t.jsonb :days, default: {
        mon: { on: nil, off: nil },
        tue: { on: nil, off: nil },
        wed: { on: nil, off: nil },
        thu: { on: nil, off: nil },
        fri: { on: nil, off: nil },
        sat: { on: nil, off: nil },
        sun: { on: nil, off: nil }
      }
    end
  end
end
