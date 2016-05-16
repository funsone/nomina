class PersonasController < ApplicationController
    before_filter :authenticate_usuario!

    before_action :set_persona, only: [:show, :edit, :update, :destroy, :cambiarestado, :enviar]

    # GET /personas
    # GET /personas.json
    def index
        s = params[:search]
        d = params[:departamento]
        t = params[:tipo]
        p = params[:page]
        buscar = ((s != '' && s) || d || t)

        @personas = buscar ? Persona.activo.search(s, d,t).paginate(page: p) : Persona.activo.paginate(page: p)
        @alength = buscar ? Persona.activo.search(s, d, t).length : Persona.activo.length
        @personas_retiradas = buscar ? Persona.retirado.search(s, d, t).paginate(page: p) : Persona.retirado.paginate(page: p)
        @slength = buscar ? Persona.suspendido.search(s, d, t).length : Persona.suspendido.length
        @personas_suspendidas = buscar ? Persona.suspendido.search(s, d,t ).paginate(page: p) : Persona.suspendido.paginate(page: p)
        @rlength = buscar ? Persona.retirado.search(s, d,t ).length : Persona.retirado.length
    end

    # GET /personas/1
    # GET /personas/1.json
    def enviar
        @persona.calculo
        p = params[:redir] ? params[:redir] : ''
        PersonaMailer.recibo(@persona).deliver_now

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
            format.html do
                if @persona.valido == false
                redirect_to @persona, notice: 'La persona no tiene registros para esa fecha.'
                end
            end

            format.pdf do
                case params[:doc]
                when '0'
                    pdf = PersonaPdf.new(@persona, 0)
                    file = "Recibo_#{@persona.cedula}.pdf"
                when '1'
                    pdf = PersonaPdf.new(@persona, 1)
                    file = "Recibo_#{@persona.cedula}_ECO.pdf"
                when '2'
                    pdf = ConstanciaPdf.new(@persona, 0)
                    file = "ConstanciaTrabajo_#{@persona.cedula}.pdf"
                when '3'
                    pdf = ConstanciaPdf.new(@persona, 1)
                    file = "ConstanciaTrabajo_#{@persona.cedula}_ECO.pdf"
                end
                send_data pdf.render, filename: file,
                                      type: 'application/pdf',
                                      disposition: 'inline'
            end
        end
    end

    def cambiarestado
        msg = 'El cambio de estado no puede ser procesado'
        log("Se ha cambiado el estado de #{@lt}", 1)
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
      authorize! :create, Persona
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
      authorize! :update, Persona
        @editable = false
    end

    # POST /personas
    # POST /personas.json
    def create
          authorize! :create, Persona
        @persona = Persona.new(persona_params)

        respond_to do |format|
            if @persona.save
                log("Se ha contratado a #{@lt}", 0)
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
          authorize! :update, Persona


        respond_to do |format|
            if @persona.update(persona_params)
                log("Se ha editado a #{@lt}", 1)
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
          authorize! :destroy, Persona
        @persona.cargo.update(disponible: true)
        @persona.destroy
        log("Se ha eliminado a #{@persona.cedula}", 2)
        respond_to do |format|
            format.html { redirect_to personas_url, notice: 'El empleado fue despedido.' }
            format.json { head :no_content }
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_persona
      if(Persona.where(id: params[:id] ).length>0)
      @persona = Persona.find(params[:id])
        @lt= '<a href="'+persona_path(@persona)+'"> '+@persona.cedula+'</a>'
      else
        respond_to do |format|
            format.html { redirect_to personas_url, alert: 'Persona no encontrada en la base de datos.' }
          end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def persona_params
        params.require(:persona).permit(:cedula, :tipo_de_cedula, :cuenta, :FAOV, :TSS, :IVSS, :caja_de_ahorro, :nombres, :apellidos, :telefono_fijo, :telefono_movil, :avatar, :fecha_de_nacimiento, :correo, :direccion, :sexo, :cargo_id,
                                        registrosconceptos_attributes: [:id, :conceptopersonal_id, :modalidad_de_pago, :_destroy, formulaspersonales_attributes: [:id, :empleado, :patrono, :_destroy]],
                                        contrato_attributes: [:id, :fecha_inicio, :fecha_fin, :sueldo_externo, :tipo_de_contrato], familiares_attributes: [:id, :cedula, :nombres, :apellidos, :fecha_de_nacimiento, :sexo, :direccion, :_destroy])
    end
end
