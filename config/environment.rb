# Load the Rails application.
require File.expand_path('../application', __FILE__)
def truncar(n)
  require 'bigdecimal'

  BigDecimal(n.to_s).truncate(2).to_f
end
def tr(n)
  '%.2f' % truncar(n)
end
def log(elemento, clase, tipo_de_accion)
  Registro.create(elemento: elemento,
                  clase: clase,
                  tipo_de_accion: tipo_de_accion)
end

# Initialize the Rails application.
Rails.application.initialize!
