class Persona < ActiveRecord::Base
  belongs_to :cargo
  has_one :contrato,  :dependent => :destroy
  accepts_nested_attributes_for :contrato
end
