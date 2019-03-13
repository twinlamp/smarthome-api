class CreateSensorValues < ActiveRecord::Migration[5.2]
  def change
    create_table :sensor_values do |t|
      t.references :sensor, foreign_key: true
      t.decimal :value
      t.datetime :registered_at
    end
  end
end
