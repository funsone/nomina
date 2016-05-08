class Departamento < ActiveRecord::Base
  resourcify
  has_many :cargos ,  :dependent => :destroy
  validates :nombre, uniqueness: { case_sensitive: false }, presence: true
end
