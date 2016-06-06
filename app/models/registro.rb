class Registro < ActiveRecord::Base
  resourcify
  belongs_to :usuario
    self.per_page = 25
    before_create :cu
    def cu
      self.usuario_id=Usuario.current
    end
end
