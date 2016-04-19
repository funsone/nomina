class CreateConceptopersonales < ActiveRecord::Migration
  def change
    create_table :conceptopersonales do |t|
      t.string :nombre
      t.integer :tipo_de_concepto

      t.timestamps null: false
    end
  end
end
