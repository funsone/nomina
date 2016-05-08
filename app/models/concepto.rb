class Concepto < ActiveRecord::Base
  resourcify
has_and_belongs_to_many :tipos
validates :nombre, uniqueness: true, presence: true
validates :formula, :modalidad_de_pago, :formula_patrono, presence: true
end
