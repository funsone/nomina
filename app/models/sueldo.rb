class Sueldo < ActiveRecord::Base
  belongs_to :cargo
  validates :monto,:sueldo_integral, presence: true, numericality: true

end
