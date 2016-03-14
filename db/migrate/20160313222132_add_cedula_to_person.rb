class AddCedulaToPerson < ActiveRecord::Migration
  def change
    add_column :people, :cedula, :string, :unique => true
  end
end
