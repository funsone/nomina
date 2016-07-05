class CreateJoinTablePersonasRequisitos < ActiveRecord::Migration
  def change
    create_join_table :requisitos, :personas do |t|
      # t.index [:requisito_id, :persona_id]
      # t.index [:persona_id, :requisito_id]
    end
  end
end
