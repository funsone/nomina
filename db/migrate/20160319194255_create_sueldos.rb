class CreateSueldos < ActiveRecord::Migration
  def change
    create_table :sueldos do |t|
      t.float :monto
      t.boolean :activo, :default =>true
      t.references :cargo, index: true, foreign_key: true
      t.float :sueldo_integral
      t.timestamps null: false
    end
  end
end
