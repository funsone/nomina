class AddFaovIvssTssToPersonas < ActiveRecord::Migration
  def change
    add_column :personas, :FAOV, :boolean
    add_column :personas, :IVSS, :boolean
    add_column :personas, :TSS, :boolean
  end
end
