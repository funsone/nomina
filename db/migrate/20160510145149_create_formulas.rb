class CreateFormulas < ActiveRecord::Migration
  def change
    create_table :formulas do |t|
      t.references :concepto, index: true, foreign_key: true
      t.string :empleado
      t.string :patrono
      t.boolean :activo, :default =>true

      t.timestamps null: false

    end
  end
end
