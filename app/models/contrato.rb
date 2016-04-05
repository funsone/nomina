class Contrato < ActiveRecord::Base
  belongs_to :persona
  validates :tipo_de_contrato,:fecha_inicio, presence: true
  validates :tipo_de_contrato, numericality: { only_integer: true }
  validates :sueldo_externo, numericality: true, allow_blank: true
  validates :fecha_inicio, date: { before: proc { Time.now + 1.day}, message: 'es invalida. No puede iniciar el contrato en fechas futuras.' }
  validates :fecha_fin, date: { after: proc {:fecha_inicio}, message: 'es invalida. El contrato no puede finalizar antes de iniciar.' }, allow_blank: true
end
