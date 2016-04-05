class Cargo < ActiveRecord::Base
  belongs_to :departamento
  has_one :persona,  :dependent => :destroy
  belongs_to :tipo
  has_many :sueldos ,  :dependent => :destroy
  accepts_nested_attributes_for :sueldos
    paginates_per 10
      validates :nombre, uniqueness: { case_sensitive: false }, presence: true
      

end
