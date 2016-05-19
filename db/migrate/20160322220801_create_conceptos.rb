class CreateConceptos < ActiveRecord::Migration
  def change
    create_table :conceptos do |t|
      t.string :nombre
      t.integer :modalidad_de_pago
      t.integer :condicion
      t.timestamps null: false
    end
  end
end
