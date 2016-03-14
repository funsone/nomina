class CreatePayrolls < ActiveRecord::Migration
  def change
    create_table :payrolls do |t|
      t.string :nombre

      t.timestamps null: false
    end
  end
end
