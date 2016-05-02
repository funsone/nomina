class CreateRegistros < ActiveRecord::Migration
  def change
    create_table :registros do |t|
      t.string :descripcion
      t.references :usuario, index: true, foreign_key: true
      t.integer :tipo_de_accion

      t.timestamps null: false
    end
  end
end
