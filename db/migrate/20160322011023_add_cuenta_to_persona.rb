class AddCuentaToPersona < ActiveRecord::Migration
  def change
    add_column :personas, :cuenta, :string
  end
end
