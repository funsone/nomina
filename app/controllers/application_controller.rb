class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception



  $dic = Hash['tipos_de_contrato' => Hash['Fijo' => 0, 'Temporal' => 1, 'Comision de servicio' => 2],
              'sexos' => Hash['Masculino' => 0, 'Femenino' => 1],
              'tipos_de_cedula' => Hash['V-' => 0, 'E-' => 1],
              'quincena' => Hash['Primera Quincena ' => 0, 'Segunda Quincena ' => 1],
              'modalidad_de_pago' => Hash['Unico (Quincena actual)'=>0,'Unico (siguiente quincena)'=>1,'Fijo (primera quincena)'=>2,'Fijo (segunda quincena)'=>3,'Fijo (Ambas Quincena)'=>4],
              'tipos_de_conceptos' =>Hash['Asignacion'=>0,'Deduccion'=>1],
              'modos_de_pago' => Hash['Primera Quincena'=>0,'Segunda Quincena'=>1,'Ambas'=>2],
              'meses' => Hash['ENERO'=>1,'FEBRERO'=>2,'MARZO'=>3,
                              'ABRIL'=>4 ,'MAYO'=>5,'JUNIO'=>6,
                              'JULIO'=>7 ,'AGOSTO'=>8,'SETIEMBRE'=>9,
                              'OCTUBRE'=>10 ,'NOVIEMBRE'=>11,'DICIEMBRE'=>12]]

  $ahora=Time.now.in_time_zone("America/Caracas")
  $quincena=0
  if $ahora.day <=15
    $quincena=0
  else
    $quincena=1
  end
end
