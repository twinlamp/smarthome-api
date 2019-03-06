class CreateDevices < ActiveRecord::Migration[5.2]
  def change
    create_table :devices do |t|
      t.references :user, foreign_key: true
      t.string :name
      t.string :identity
      t.string :timezone
    end
  end
end
