class Cargo < ActiveRecord::Base
  belongs_to :departamento
  has_one :persona
  belongs_to :tipo
  has_many :sueldos ,  :dependent => :destroy
  accepts_nested_attributes_for :sueldos
end
