class PersonasController < ApplicationController
  before_filter :authenticate_usuario!

  before_action :set_persona, only: [:show, :edit, :update, :destroy, :cambiarestado, :enviar]

  # GET /personas
  # GET /personas.json
  def index
    s = params[:search]
    d = params[:departamento]
    p = params[:page]
    buscar = ((s != '' && s) || d)

    @personas = buscar ? Persona.activo.search(s, d).paginate(page: p) : Persona.activo.paginate(page: p)
    @alength = buscar ? Persona.activo.search(s, d).length : Persona.activo.length
    @personas_retiradas = buscar ? Persona.retirado.search(s, d).paginate(page: p) : Persona.retirado.paginate(page: p)
    @slength = buscar ? Persona.suspendido.search(s, d).length : Persona.suspendido.length
    @personas_suspendidas = buscar ? Persona.suspendido.search(s, d).paginate(page: p) : Persona.suspendido.paginate(page: p)
    @rlength = buscar ? Persona.retirado.search(s, d).length : Persona.retirado.length

    #  if params[:search]!="" and params[:search]

    #    @personas = Persona.activo.search(params[:search],params[:departamento]).paginate(page: params[:page])
    #  @personas_retiradas = Persona.retirado.search(params[:search],params[:departamento]).paginate(page: params[:page])
    #  @personas_suspendidas = Persona.suspendido.search(params[:search],params[:departamento]).paginate( page: params[:page])
    #  @alength=Persona.activo.search(params[:search],params[:departamento]).length
    #  @slength=Persona.suspendido.search(params[:search],params[:departamento]).length
    #  @rlength=Persona.retirado.search(params[:search],params[:departamento]).length

    #  else
    #
    #    @personas = Persona.activo.order(:cedula).paginate( page: params[:page])
    #    @personas_retiradas = Persona.retirado.order(:cedula).paginate( page: params[:page])
    #        @personas_suspendidas = Personauspendido.order(:cedula).paginate( page: params[:page])
    #        @alength=Persona.activo.length
    #        @slength=Persona.suspendido.length
    #        @rlength=Persona.retirado.length
    #    end.suspendido.order(:cedula).paginate( page: params[:page])
    #        @alength=Persona.activo.length
    #        @slength=Persona.suspendido.length
    #        @rlength=Persona.retirado.length
    #    end
  end

  # GET /personas/1
  # GET /personas/1.json
  def enviar
    @persona.calculo
    PersonaMailer.recibo(@persona).deliver_now
    p = params[:redir] ? params[:redit] : ''
    if p == ''

      respond_to do |format|
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to @persona, notice: 'Recibo enviado' }
      end
    end
  end

  def show
    @persona.calculo

    respond_to do |format|
      format.html
      format.pdf do
        if params[:doc] == '0'
          pdf = PersonaPdf.new(@persona)
          send_data pdf.render, filename: "#{@persona.cedula}_recibo",
                                type: 'application/pdf',
                                disposition: 'inline'
        elsif params[:doc] == '1'

          pdf = ConstanciaPdf.new(@persona)
          send_data pdf.render, filename: "#{@persona.cedula}_constancia",
                                type: 'application/pdf',
                                disposition: 'inline'
        end
      end
    end
  end

  def cambiarestado
    msg = 'El cambio de estado no puede ser procesado'
    case params[:estado]
    when '0'
      @persona.retirar!
      msg = 'El empleado se ha retirado'
    when '1'
      @persona.reactivar!
      msg = 'El empleado a sido reactivado'
    when '2'
      @persona.reingresar!
      msg = 'El empleado a sido recontratado'
    when '3'
      @persona.suspender!
      msg = 'El empleado a sido suspendido'
    end
    respond_to do |format|
      format.html { redirect_to @persona, notice: msg }
      format.json { head :no_content }
    end
  end

  # GET /personas/new
  def new
    @editable = true
    if Cargo.where('disponible=true').length <= 0
      respond_to do |format|
        format.html { redirect_to personas_url, alert: 'No hay cargo disponibles.' }
        format.json { render json: @persona.errors, status: 'No hay cargos disponibles' }
      end
    else
      @persona = Persona.new
      @persona.contrato = Contrato.new
    end
  end

  # GET /personas/1/edit
  def edit
    @editable = false
  end

  # POST /personas
  # POST /personas.json
  def create
    @persona = Persona.new(persona_params)

    respond_to do |format|
      if @persona.save
        @persona.cargo.disponible = false
        @persona.cargo.save
        #  Cargo.where(id: params[:cargo_id]).update_all(disponible: false);
        format.html { redirect_to @persona, notice: 'La persona fue contratada exitosamente.' }
        format.json { render :show, status: :created, location: @persona }
      else
        format.html { render :new }
        format.json { render json: @persona.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /personas/1
  # PATCH/PUT /personas/1.json
  def update
    respond_to do |format|
      if @persona.update(persona_params)
        format.html { redirect_to @persona, notice: 'Los datos del empleado fueron actualizados exitosamente.' }
        format.json { render :show, status: :ok, location: @persona }
      else
        format.html { render :edit }
        format.json { render json: @persona.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /personas/1
  # DELETE /personas/1.json
  def destroy
    @persona.cargo.update(disponible: true)
    @persona.destroy
    respond_to do |format|
      format.html { redirect_to personas_url, notice: 'El empleado fue despedido.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_persona
    @persona = Persona.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def persona_params
    params.require(:persona).permit(:cedula, :tipo_de_cedula, :cuenta, :FAOV, :TSS, :IVSS, :caja_de_ahorro, :nombres, :apellidos, :telefono_fijo, :telefono_movil, :avatar, :fecha_de_nacimiento, :correo, :direccion, :sexo, :cargo_id,
                                    registrosconceptos_attributes: [:id, :formula, :conceptopersonal_id,:formula_patrono, :modalidad_de_pago, :_destroy],
                                    contrato_attributes: [:id, :fecha_inicio, :fecha_fin, :sueldo_externo, :tipo_de_contrato], familiares_attributes: [:id, :cedula, :nombres, :apellidos, :fecha_de_nacimiento, :sexo, :direccion, :_destroy])
  end
end
