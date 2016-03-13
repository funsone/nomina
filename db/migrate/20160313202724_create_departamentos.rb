class CreateDepartamentos < ActiveRecord::Migration
  def change
    create_table :departamentos do |t|
      t.string :nombre
      t.references :sede, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
