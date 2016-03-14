class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.string :titulo
      t.decimal :sueldo
      t.boolean :sueldo_minimo
      t.references :department, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
