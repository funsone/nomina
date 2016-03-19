class Cargo < ActiveRecord::Base
  belongs_to :departamento
  has_many :sueldos
  accepts_nested_attributes_for :sueldos
end
