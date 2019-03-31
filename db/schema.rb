# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_03_26_142242) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "devices", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.string "identity"
    t.string "timezone"
    t.index ["user_id"], name: "index_devices_on_user_id"
  end

  create_table "relays", force: :cascade do |t|
    t.bigint "device_id"
    t.bigint "sensor_id"
    t.string "name"
    t.integer "order"
    t.string "conf_name"
    t.boolean "value"
    t.string "icon"
    t.integer "state", default: 0
    t.index ["device_id"], name: "index_relays_on_device_id"
    t.index ["sensor_id"], name: "index_relays_on_sensor_id"
  end

  create_table "sensor_values", force: :cascade do |t|
    t.bigint "sensor_id"
    t.decimal "value"
    t.datetime "registered_at"
    t.index ["sensor_id"], name: "index_sensor_values_on_sensor_id"
  end

  create_table "sensors", force: :cascade do |t|
    t.bigint "device_id"
    t.string "icon"
    t.string "name"
    t.integer "order"
    t.decimal "value", precision: 10, scale: 2
    t.string "conf_name"
    t.decimal "min", precision: 10, scale: 2
    t.decimal "max", precision: 10, scale: 2
    t.index ["device_id"], name: "index_sensors_on_device_id"
  end

  create_table "task_schedules", force: :cascade do |t|
    t.bigint "task_id"
    t.datetime "start"
    t.datetime "stop"
    t.jsonb "days", default: {"fri"=>{"on"=>nil, "off"=>nil}, "mon"=>{"on"=>nil, "off"=>nil}, "sat"=>{"on"=>nil, "off"=>nil}, "sun"=>{"on"=>nil, "off"=>nil}, "thu"=>{"on"=>nil, "off"=>nil}, "tue"=>{"on"=>nil, "off"=>nil}, "wed"=>{"on"=>nil, "off"=>nil}}
    t.index ["task_id"], name: "index_task_schedules_on_task_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.bigint "relay_id"
    t.bigint "sensor_id"
    t.decimal "min", precision: 10, scale: 2
    t.decimal "max", precision: 10, scale: 2
    t.index ["relay_id"], name: "index_tasks_on_relay_id"
    t.index ["sensor_id"], name: "index_tasks_on_sensor_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
  end

  add_foreign_key "devices", "users"
  add_foreign_key "relays", "devices"
  add_foreign_key "relays", "sensors"
  add_foreign_key "sensor_values", "sensors"
  add_foreign_key "sensors", "devices"
  add_foreign_key "task_schedules", "tasks"
  add_foreign_key "tasks", "relays"
  add_foreign_key "tasks", "sensors"
end
