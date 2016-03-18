class CreateHeadquarters < ActiveRecord::Migration
  def change
    create_table :headquarters do |t|
      t.string :nombre

      t.timestamps null: false
    end
  end
end
