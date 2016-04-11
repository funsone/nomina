class CreateFamiliares < ActiveRecord::Migration
  def change
    create_table :familiares do |t|
      t.integer :cedula
      t.string :nombres
      t.string :apellidos
      t.date :fecha_de_nacimiento
      t.boolean :sexo
      t.string :direccion
      t.references :persona, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
