class AddDisponibleToCargos < ActiveRecord::Migration
  def change
    add_column :cargos, :disponible, :boolean, :default =>true
  end
end
