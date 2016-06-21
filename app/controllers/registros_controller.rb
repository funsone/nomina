class RegistrosController < ApplicationController
  before_filter :authenticate_usuario!
  before_action :redir, only: [ :edit, :update,:new]
  before_action :set_registro, only: [ :show]

  # GET /registros
  # GET /registros.json
  def geturl (reg)

    case reg.clase
    when 0
      return concepto_path(reg.elemento)
      when 1
          return conceptopersonal_path(reg.elemento)
      when 2
          return departamento_path(reg.elemento)
      when 3
          return dependencia_path(reg.elemento)
      when 4
          return persona_path(reg.elemento)
      when 5
          return tipo_path(reg.elemento)
      when 6
          return cargo_path(reg.elemento)
    end
  end
  helper_method :geturl
  def index
    authorize! :read, Registro

    p = params[:page]
    @registros = Registro.order("created_at DESC").paginate(page: p)

  end
  def destroy
        authorize! :destroy, Registro
    Registro.destroy_all
    respond_to do |format|
      format.html { redirect_to registros_url, notice: 'Registro limpiado exitosamente.' }
      format.json { head :no_content }
    end
  end
  # GET /registros/1
  # GET /registros/1.json
  def show
@url=geturl(@registro)
    respond_to do |format|
        format.html

    end


  end

  # GET /registros/new
  def new

  end

  # GET /registros/1/edit
  def edit
  end

  # POST /registros
  # POST /registros.json
  def create
  end

  # PATCH/PUT /registros/1
  # PATCH/PUT /registros/1.json
  def update
  end
private
def redir
  respond_to do |format|
    format.html { redirect_to registros_url}
    format.json { head :no_content }
  end
end
  # DELETE /registros/1
  # DELETE /registros/1.json
  def set_registro
    if(Registro.where(id: params[:id] ).length>0)
    @registro = Registro.find(params[:id])

    else
      respond_to do |format|
          format.html { redirect_to personas_url, alert: 'El registro no se encuentra en la base de datos.' }
        end
    end
  end
end
