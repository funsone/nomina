class AddNormalToSueldos < ActiveRecord::Migration
  def change
    add_column :sueldos, :normal, :float, default: 0

  end
end
