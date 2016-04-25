class Departamento < ActiveRecord::Base
  has_many :cargos ,  :dependent => :destroy
  validates :nombre, uniqueness: { case_sensitive: false }, presence: true
end
