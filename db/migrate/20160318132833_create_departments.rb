class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :nombre
      t.references :headquarter, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
