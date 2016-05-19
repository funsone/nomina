class CreateFormulaspersonales < ActiveRecord::Migration
  def change
    create_table :formulaspersonales do |t|
      t.string :empleado
      t.string :patrono
      t.boolean :activo, :default =>true
      t.references :registroconcepto, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
