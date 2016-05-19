class Registroconcepto < ActiveRecord::Base
	has_many :formulaspersonales ,  :dependent => :destroy
  accepts_nested_attributes_for :formulaspersonales
	belongs_to :persona
	belongs_to :conceptopersonal
	validates :conceptopersonal_id, presence: true
	validates :modalidad_de_pago, presence: true
	after_update :actualizar
	protected
		def actualizar

		end

end
