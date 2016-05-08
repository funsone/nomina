class ApplicationController < ActionController::Base
    before_filter :set_ahora
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    # encoding: utf-8
    protect_from_forgery with: :exception
def current_user
current_usuario
end

    def log (descripcion, tipo_de_accion)
      Registro.create(descripcion: descripcion, tipo_de_accion: tipo_de_accion, usuario_id: current_usuario.id)

    end
    $dic = Hash['tipos_de_contrato' => Hash['Fijo' => 0, 'Temporal' => 1, 'Comision de servicio' => 2],
                'sexos' => Hash['Masculino' => 0, 'Femenino' => 1],
                'tipos_de_cedula' => Hash['V-' => 0, 'E-' => 1],
                'quincena' => Hash['Primera Quincena ' => 0, 'Segunda Quincena ' => 1],
                'modalidad_de_pago' => Hash['Unico (Quincena actual)' => 0, 'Unico (siguiente quincena)' => 1, 'Fijo (primera quincena)' => 2, 'Fijo (segunda quincena)' => 3, 'Fijo (Ambas Quincena)' => 4],
                'tipos_de_conceptos' => Hash['Asignacion' => 0, 'Deduccion' => 1],
                'modos_de_pago' => Hash['Primera Quincena' => 0, 'Segunda Quincena' => 1, 'Ambas' => 2],
                'tipo_de_accion' => Hash['success' => 0, 'info' => 1, 'danger' => 2],
                'meses' => Hash['ENERO' => 1, 'FEBRERO' => 2, 'MARZO' => 3,
                                'ABRIL' => 4, 'MAYO' => 5, 'JUNIO' => 6,
                                'JULIO' => 7, 'AGOSTO' => 8, 'SETIEMBRE' => 9,
                                'OCTUBRE' => 10, 'NOVIEMBRE' => 11, 'DICIEMBRE' => 12],
                'condiciones' => Hash['Ninguna' => 0, 'FAOV' => 1, 'IVSS' => 2, 'TSS' => 3, 'CAJA DE AHORRO' => 4]]

    def set_ahora
        $ahora = params[:ahora] ? params[:ahora].to_time : Time.now.in_time_zone('America/Caracas')
        $quincena = ($ahora.day <= 15) ? 0 : 1
    end

    rescue_from CanCan::AccessDenied do |_exception|
        flash[:error] = 'Acceso denegado.'
        redirect_to root_url
    end
end
