class AddDependeciaToDepartartamento < ActiveRecord::Migration
  def change
    add_reference :departamentos, :dependencia, index: true, foreign_key: true
  end
end
