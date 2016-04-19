class CreateConceptospersonales < ActiveRecord::Migration
  def change
    create_table :conceptospersonales do |t|
      t.string :nombre
      t.integer :tipo_de_concepto

      t.timestamps null: false
    end
  end
end
