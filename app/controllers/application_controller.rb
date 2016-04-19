class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  $dicc=Hash["tipos_de_conceptos" =>Hash["Asignaciones"=>false,"Deducciones"=>true],
             "modos_de_pago" => Hash["Primera Quincena"=>0,"Segunda Quincena"=>1,"Ambas"=>2]]
  $dic = Hash['tipos_de_contrato' => Hash['Fijo' => 0, 'Temporal' => 1, 'Externo' => 2],

              'sexos' => Hash['Masculino' => 0, 'Femenino' => 1],
              'tipos_de_cedula' => Hash['V-' => 0, 'E-' => 1],
              'modalidad_de_pago' => Hash['V-' => 0, 'E-' => 1]]
end
