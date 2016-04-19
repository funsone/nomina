class CreateRegistrosconceptos < ActiveRecord::Migration
  def change
    create_table :registrosconceptos do |t|
      t.references :conceptopersonal
      t.string :formula
      t.integer :modalidad_de_pago
      t.references :persona

      t.timestamps null: false
    end
  end
end
