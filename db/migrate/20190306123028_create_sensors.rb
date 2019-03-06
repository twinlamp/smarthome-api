class CreateSensors < ActiveRecord::Migration[5.2]
  def change
    create_table :sensors do |t|
      t.references :device, foreign_key: true
      t.string :icon
      t.string :name
      t.integer :order
      t.decimal :value, precision: 10, scale: 2
      t.string :conf_name
      t.decimal :min, precision: 10, scale: 2
      t.decimal :max, precision: 10, scale: 2
    end
  end
end
