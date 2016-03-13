class CreateSedes < ActiveRecord::Migration
  def change
    create_table :sedes do |t|
      t.string :nombre

      t.timestamps null: false
    end
  end
end
