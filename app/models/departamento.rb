class Departamento < ActiveRecord::Base
  has_many :cargos ,  :dependent => :destroy
end
