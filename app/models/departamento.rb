class Departamento < ActiveRecord::Base
  has_many :cargos ,  :dependent => :destroy
  paginates_per 10
  validates :nombre, uniqueness: { case_sensitive: false }, presence: true
end
