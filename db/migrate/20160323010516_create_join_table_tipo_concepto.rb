class CreateJoinTableTipoConcepto < ActiveRecord::Migration
  def change
    create_join_table :tipos, :conceptos do |t|
      # t.index [:tipo_id, :concepto_id]
      # t.index [:concepto_id, :tipo_id]
    end
  end
end
