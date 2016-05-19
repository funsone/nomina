class Concepto < ActiveRecord::Base
  resourcify
  has_many :formulas, dependent: :destroy
  accepts_nested_attributes_for :formulas
  has_and_belongs_to_many :tipos
  validates :nombre, uniqueness: true, presence: true
  validates :modalidad_de_pago, presence: true
end
