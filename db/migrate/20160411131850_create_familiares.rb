class CreateFamiliares < ActiveRecord::Migration
  def change
    create_table :familiares do |t|
      t.integer :tipo_de_cedula
      t.integer :cedula
      t.string :nombres
      t.string :parentesco
      t.string :apellidos
      t.date :fecha_de_nacimiento
      t.integer :sexo
      t.string :direccion
      t.references :persona, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
