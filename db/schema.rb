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

ActiveRecord::Schema.define(version: 20160430204909) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cargos", force: :cascade do |t|
    t.string   "nombre"
    t.integer  "departamento_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "tipo_id"
    t.boolean  "disponible",      default: true
  end

  add_index "cargos", ["departamento_id"], name: "index_cargos_on_departamento_id", using: :btree
  add_index "cargos", ["tipo_id"], name: "index_cargos_on_tipo_id", using: :btree

  create_table "conceptopersonales", force: :cascade do |t|
    t.string   "nombre"
    t.integer  "tipo_de_concepto"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "conceptos", force: :cascade do |t|
    t.string   "nombre"
    t.string   "formula"
    t.integer  "modalidad_de_pago"
    t.string   "formula_patrono"
    t.integer  "condicion"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "tipo_de_concepto"
  end

  create_table "conceptos_tipos", id: false, force: :cascade do |t|
    t.integer "tipo_id",     null: false
    t.integer "concepto_id", null: false
  end

  create_table "conceptospersonales", force: :cascade do |t|
    t.string   "nombre"
    t.integer  "tipo_de_concepto"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "contratos", force: :cascade do |t|
    t.date     "fecha_inicio"
    t.date     "fecha_fin"
    t.integer  "tipo_de_contrato"
    t.decimal  "sueldo_externo"
    t.integer  "persona_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "contratos", ["persona_id"], name: "index_contratos_on_persona_id", using: :btree

  create_table "departamentos", force: :cascade do |t|
    t.string   "nombre"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "dependencia_id"
  end

  add_index "departamentos", ["dependencia_id"], name: "index_departamentos_on_dependencia_id", using: :btree

  create_table "dependencias", force: :cascade do |t|
    t.string   "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "familiares", force: :cascade do |t|
    t.integer  "cedula"
    t.string   "nombres"
    t.string   "apellidos"
    t.date     "fecha_de_nacimiento"
    t.integer  "sexo"
    t.string   "direccion"
    t.integer  "persona_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "familiares", ["persona_id"], name: "index_familiares_on_persona_id", using: :btree

  create_table "personas", force: :cascade do |t|
    t.string   "cedula"
    t.integer  "tipo_de_cedula"
    t.string   "nombres"
    t.string   "apellidos"
    t.string   "telefono_fijo"
    t.string   "telefono_movil"
    t.date     "fecha_de_nacimiento"
    t.string   "correo"
    t.string   "direccion"
    t.integer  "sexo"
    t.string   "status",              default: "activo"
    t.integer  "cargo_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "cuenta"
    t.boolean  "FAOV"
    t.boolean  "IVSS"
    t.boolean  "TSS"
    t.boolean  "caja_de_ahorro"
  end

  add_index "personas", ["cargo_id"], name: "index_personas_on_cargo_id", using: :btree

  create_table "registros", force: :cascade do |t|
    t.string   "descripcion"
    t.integer  "usuario_id"
    t.integer  "tipo_de_accion"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "registros", ["usuario_id"], name: "index_registros_on_usuario_id", using: :btree

  create_table "registrosconceptos", force: :cascade do |t|
    t.integer  "conceptopersonal_id"
    t.string   "formula"
    t.string   "formula_patrono"
    t.integer  "modalidad_de_pago"
    t.integer  "persona_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "settings", force: :cascade do |t|
    t.string   "var",                   null: false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true, using: :btree

  create_table "sueldos", force: :cascade do |t|
    t.decimal  "monto"
    t.boolean  "activo",          default: true
    t.integer  "cargo_id"
    t.decimal  "sueldo_integral"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "sueldos", ["cargo_id"], name: "index_sueldos_on_cargo_id", using: :btree

  create_table "tipos", force: :cascade do |t|
    t.string   "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "usuarios", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "rol_id"
  end

  add_index "usuarios", ["email"], name: "index_usuarios_on_email", unique: true, using: :btree
  add_index "usuarios", ["reset_password_token"], name: "index_usuarios_on_reset_password_token", unique: true, using: :btree
  add_index "usuarios", ["rol_id"], name: "index_usuarios_on_rol_id", using: :btree

  add_foreign_key "cargos", "departamentos"
  add_foreign_key "cargos", "tipos"
  add_foreign_key "contratos", "personas"
  add_foreign_key "departamentos", "dependencias"
  add_foreign_key "familiares", "personas"
  add_foreign_key "personas", "cargos"
  add_foreign_key "registros", "usuarios"
  add_foreign_key "sueldos", "cargos"
  add_foreign_key "usuarios", "roles"
end
