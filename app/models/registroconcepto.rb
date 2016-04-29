class Registroconcepto < ActiveRecord::Base
	belongs_to :persona
	belongs_to :conceptopersonal
	validates :conceptopersonal_id, presence: true
	validates :formula,:modalidad_de_pago,:formula_patrono, presence: true
end
