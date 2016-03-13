class CreatePersonas < ActiveRecord::Migration
  def change
    create_table :personas do |t|
      t.integer :tipo_cedula
      t.integer :cedula
      t.string :nombres
      t.string :apellidos
      t.references :lista, index: true, foreign_key: true
      t.string :telefono_fijo
      t.string :telefono_movil
      t.date :fecha_de_nacimiento
      t.string :correo
      t.string :direccion
      t.boolean :sexo
      t.integer :estado_civil
      t.integer :grado
      t.integer :status

      t.timestamps null: false
    end
  end
end
