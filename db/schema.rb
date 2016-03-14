# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160313222132) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "departments", force: :cascade do |t|
    t.string   "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payrolls", force: :cascade do |t|
    t.string   "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "people", force: :cascade do |t|
    t.integer  "payroll_id"
    t.boolean  "tipo_cedula"
    t.string   "nombres"
    t.string   "apellidos"
    t.string   "telefono_fijo"
    t.string   "telefono_movil"
    t.date     "fecha_de_nacimiento"
    t.string   "correo"
    t.string   "direccion"
    t.boolean  "sexo"
    t.integer  "estado_civil"
    t.integer  "grado"
    t.integer  "status"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "cedula"
  end

  add_index "people", ["payroll_id"], name: "index_people_on_payroll_id", using: :btree

  create_table "positions", force: :cascade do |t|
    t.string   "titulo"
    t.decimal  "sueldo"
    t.boolean  "sueldo_minimo"
    t.integer  "department_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "positions", ["department_id"], name: "index_positions_on_department_id", using: :btree

  add_foreign_key "people", "payrolls"
  add_foreign_key "positions", "departments"
end
