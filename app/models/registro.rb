class Registro < ActiveRecord::Base
  belongs_to :usuario
    self.per_page = 10
end
