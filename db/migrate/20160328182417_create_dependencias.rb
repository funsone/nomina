class CreateDependencias < ActiveRecord::Migration
  def change
    create_table :dependencias do |t|
      t.string :nombre

      t.timestamps null: false
    end
  end
end
