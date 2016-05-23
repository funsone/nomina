class CreateSueldos < ActiveRecord::Migration
  def change
    create_table :sueldos do |t|
      t.money :monto
      t.boolean :activo, :default =>true
      t.references :cargo, index: true, foreign_key: true
      t.money :sueldo_integral
      t.timestamps null: false
    end
  end
end
