class CreateHistoriales < ActiveRecord::Migration
  def change
    create_table :historiales do |t|
      t.references :persona, index: true, foreign_key: true
      t.references :cargo, index: true, foreign_key: true
      t.date :fecha_inicio
      t.date :fecha_fin

      t.timestamps null: false
    end
  end
end
