class Sueldo < ActiveRecord::Base
  belongs_to :cargo
  validates :monto, presence: true, numericality: true
end
