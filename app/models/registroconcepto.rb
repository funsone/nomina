class Registroconcepto < ActiveRecord::Base
	has_many :formulaspersonales ,  :dependent => :destroy
  accepts_nested_attributes_for :formulaspersonales
	belongs_to :persona
	belongs_to :conceptopersonal
	validates :conceptopersonal_id, presence: true
	validates :modalidad_de_pago, presence: true
	before_update :actualizar

	protected
		def actualizar

			nuevo = false
			if $quincena == 0
				nuevo =Formulapersonal.where(registroconcepto_id: id).where(created_at: Time.now.beginning_of_month..(Time.now.beginning_of_month + 14.days)).empty?
			else
				nuevo = Formulapersonal.where(registroconcepto_id: id).where(created_at: (Time.now.beginning_of_month + 15.days)..Time.now.end_of_month).empty?
			end
			if nuevo
				viejo =Formulapersonal.where(registroconcepto_id: id).where(activo: true).last
				npatrono = formulaspersonales.last.patrono
				nempleado = formulaspersonales.last.empleado
				formulaspersonales.last.activo=false
				formulaspersonales.last.patrono=viejo.patrono
				formulaspersonales.last.empleado=viejo.empleado
				crear = formulaspersonales.new
				crear.empleado=nempleado
				crear.patrono=npatrono


			end
		end

end
