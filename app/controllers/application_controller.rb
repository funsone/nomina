# Prevent CSRF attacks by raising an exception.
# For APIs, you may want to use  =>null_session instead.
# encoding => utf-8
class ApplicationController < ActionController::Base
  before_filter :set_ahora
  protect_from_forgery with: :exception

  def current_user
    current_usuario
  end

  $dic = Hash['tipos_de_contrato' => Hash['Fijo' => 0,
                                          'Temporal' => 1,
                                          'Comisión de servicio' => 2],
              'sexos' => Hash['Masculino' => 0, 'Femenino' => 1],
              'tipos_de_cedula' => Hash['V-' => 0, 'E-' => 1],
              'tipos_de_reporte' => Hash['Recibos' => 0,
                                         'Bancarios' => 2,
                                         'Deducciones' => 4],
              'quincena'=> Hash['Primera Quincena ' => 0,
                                 'Segunda Quincena ' => 1],
              'modalidad_de_pago' => Hash['Único (Quincena actual)' => 0,
                                          'Único (Quincena siguiente)' => 1,
                                          'Fijo (Primera quincena)' => 2,
                                          'Fijo (Segunda quincena)' => 3,
                                          'Fijo (Ambas quincenas)' => 4,
                                          'Extra (Quincena Actual)' => 5,
                                          'Extra (Quincena Siguiente)' => 6],
              'tipos_de_conceptos' => Hash['Asignación' => 0, 'Deducción' => 1],
              'tipo_de_accion' => Hash['success' => 0, 'info' => 1, 'danger' => 2],
              'tipo_de_accion_def' => Hash['fa fa-star' => 0, 'fa fa-pencil' => 1, 'fa fa-trash' => 2],
              'clases' => Hash['Concepto' => 0, 'Concepto Personal' => 1, 'Departamento' => 2,
                              'Dependencia' => 3, 'Empleado' => 4, 'Nomina' => 5,
                              'Cargo' => 6
              ],
              'meses' => Hash['ENERO' => 1, 'FEBRERO' => 2, 'MARZO' => 3,
                              'ABRIL' => 4, 'MAYO' => 5, 'JUNIO' => 6,
                              'JULIO' => 7, 'AGOSTO' => 8, 'SETIEMBRE' => 9,
                              'OCTUBRE' => 10, 'NOVIEMBRE' => 11, 'DICIEMBRE' => 12],
              'condiciones' => Hash['Ninguna' => 0, 'FAOV' => 1, 'IVSS' => 2,
                                    'TSS' => 3, 'CAJA DE AHORRO' => 4],
              'parentesco' => Hash['Hijo(a)' => 0, 'Padre' => 1, 'Madre' => 2,
                                                          'Esposo(a)' => 3]]

  def set_ahora
    $ahora = params[:ahora] ? Date.strptime(params[:ahora], '%d-%m-%Y')  : Date.strptime("#{Time.now.day}-#{Time.now.mon}-#{Time.now.year}", '%d-%m-%Y')
    $quincena = ($ahora.day <= 15) ? 0  : 1

      Usuario.current = current_user if current_user

  end

  rescue_from CanCan::AccessDenied do |_exception|
    flash[:error] = 'Acceso denegado: no posee los permisos necesarios!'
    redirect_to root_url
  end
end
