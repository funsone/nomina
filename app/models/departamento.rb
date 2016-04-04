class Departamento < ActiveRecord::Base
  has_many :cargos ,  :dependent => :destroy
  paginates_per 10
end
