class CreateContratos < ActiveRecord::Migration
  def change
    create_table :contratos do |t|
      t.date :fecha_inicio
      t.date :fecha_fin
      t.integer :tipo_de_contrato
      t.decimal :sueldo_externo
      t.references :persona, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
