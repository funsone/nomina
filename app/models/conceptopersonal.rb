class Conceptopersonal < ActiveRecord::Base
	has_many :registrosconceptos, dependent: :destroy
	validates :nombre, uniqueness: true, presence: true
	validates :tipo_de_concepto, presence: true

end
