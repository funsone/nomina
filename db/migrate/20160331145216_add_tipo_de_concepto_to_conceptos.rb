class AddTipoDeConceptoToConceptos < ActiveRecord::Migration
  def change
    add_column :conceptos, :tipo_de_concepto, :boolean
  end
end
