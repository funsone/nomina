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

ActiveRecord::Schema.define(version: 20160313210034) do

  create_table "departamentos", force: :cascade do |t|
    t.string   "nombre"
    t.integer  "sede_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "departamentos", ["sede_id"], name: "index_departamentos_on_sede_id"

  create_table "lista", force: :cascade do |t|
    t.string   "nombre"
    t.integer  "sede_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "lista", ["sede_id"], name: "index_lista_on_sede_id"

  create_table "personas", force: :cascade do |t|
    t.integer  "tipo_cedula"
    t.integer  "cedula"
    t.string   "nombres"
    t.string   "apellidos"
    t.integer  "lista_id"
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
  end

  add_index "personas", ["lista_id"], name: "index_personas_on_lista_id"

  create_table "sedes", force: :cascade do |t|
    t.string   "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
