class AddTipoDeConceptoToConceptos < ActiveRecord::Migration
  def change
    add_column :conceptos, :tipo_de_concepto, :integer
  end
end
