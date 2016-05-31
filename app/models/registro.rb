class Registro < ActiveRecord::Base
  resourcify
  belongs_to :usuario
    self.per_page = 25
end
