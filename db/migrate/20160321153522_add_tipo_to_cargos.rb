class AddTipoToCargos < ActiveRecord::Migration
  def change
    add_reference :cargos, :tipo, index: true, foreign_key: true
  end
end
