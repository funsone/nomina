class CreatePersonas < ActiveRecord::Migration
  def change
    create_table :personas do |t|
      t.string :cedula
      t.integer :tipo_de_cedula
      t.string :nombres
      t.string :apellidos
      t.string :telefono_fijo
      t.string :telefono_movil
      t.date :fecha_de_nacimiento
      t.string :correo
      t.string :direccion
      t.integer :sexo
      t.string :status, default: "activo"
      t.date :fecha_envio
      t.references :cargo, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
