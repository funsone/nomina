class Sueldo < ActiveRecord::Base
  belongs_to :cargo
  validates :monto,:sueldo_integral, :normal, presence: true, numericality: true

end
