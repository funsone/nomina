class PersonasController < ApplicationController
    before_filter :authenticate_usuario!

    before_action :set_persona, only: [:show, :edit, :update, :destroy, :cambiarestado, :enviar,:disablecp]

    # GET /personas
    # GET /personas.json
    def index
        s = params[:search]
        d = params[:departamento]
        t = params[:tipo]
        p = params[:page]
        buscar = ((s != '' && s) || d || t)

        @personas = buscar ? Persona.activo.search(s, d,t).paginate(page: p) : Persona.activo.order(:id).paginate(page: p)
        @alength = buscar ? Persona.activo.search(s, d, t).length : Persona.activo.length
        @personas_retiradas = buscar ? Persona.retirado.search(s, d, t).paginate(page: p) : Persona.retirado.order(:id).paginate(page: p)
        @slength = buscar ? Persona.suspendido.search(s, d, t).length : Persona.suspendido.length
        @personas_suspendidas = buscar ? Persona.suspendido.search(s, d,t ).paginate(page: p) : Persona.suspendido.order(:id).paginate(page: p)
        @rlength = buscar ? Persona.retirado.search(s, d,t ).length : Persona.retirado.length
    end

    # GET /personas/1
    # GET /personas/1.json
    def enviar
        @persona.calculo false
        errorm=false
        p = params[:redir] ? params[:redir] : ''
        msg=''

        si_enviar=false
        if @persona.fecha_envio.nil? ==true
          si_enviar=true
        else

          min = if $ahora.day <= 15
                  Date.civil($ahora.year, $ahora.mon, 1)
                else
                  Date.civil($ahora.year, $ahora.mon, 16)
                end

          max = if $ahora.day <= 15
                  Date.civil($ahora.year, $ahora.mon, 15)
                else
                  Date.civil($ahora.year, $ahora.mon, -1)
                end
          if (min..max).cover?(@persona.fecha_envio)
          si_enviar=false
          else
            si_enviar=true
          end
        end
        begin
          if si_enviar==true or p != ''

          PersonaMailer.recibo(@persona).deliver_now
          @persona.update_column(:fecha_envio,$ahora)

          end

        rescue Exception => e
          msg='<i class="fa fa-exclamation-triangle fa-lg"></i> Recibo no enviado, verifique su conexion a internet.'
          errorm=true
        end


        if p == ''
            respond_to do |format|
              if errorm
                format.json { head :no_content }
                            else
                format.json { head :no_content }
              end
            end
        else
            respond_to do |format|
              if msg==''
                format.html { redirect_to @persona, notice: '<i class="fa fa-check-square fa-lg"></i> Recibo enviado.' }
              else
                format.html { redirect_to @persona, alert: msg }
              end
            end
        end
    end

    def show
        @persona.calculo false

        respond_to do |format|
            format.html do
                if @persona.valido == false
                redirect_to @persona, alert: '<i class="fa fa-exclamation-triangle fa-lg"></i> La persona no tiene registros para esa fecha.'
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
    def disablecp
      if (params["cp"].nil?) ==false
        c=Registroconcepto.find(params["cp"])
        if c.desactivable
        c.desactivar
        respond_to do |format|
          format.html { redirect_to persona_path(@persona), notice: '<i class="fa fa-check-square fa-lg"></i> El concepto personal fue desactivado exitosamente.' }

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
          ncargo=Cargo.find(params[:cargo_id]);
          gh=false
          gh=true if ncargo.id==@persona.cargo.id
          if(ncargo.disponible)
            @persona.cargo=ncargo
            @persona.cargo.disponible=false
            @persona.cargo.save
             @persona.save
             if gh
             @persona.generar_historial
             end
            @persona.reingresar!
            msg = '<i class="fa fa-check-square fa-lg"></i> El empleado a sido recontratado'
          else
            msg = '<i class="fa fa-exclamation-triangle fa-lg"></i> El cargo ya esta ocupado, edite el empleado y seleccione otro.'
          end
        when '3'
            @persona.suspender!
            msg = '<i class="fa fa-check-square fa-lg"></i> El empleado a sido suspendido.'
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
                format.html { redirect_to cargos_url, alert: '<i class="fa fa-exclamation-triangle fa-lg"></i> No hay cargo disponibles.' }
                format.json { render json: @persona.errors, status: 'No hay cargos disponibles.' }
            end



        end
        @persona = Persona.new
        @persona.contrato=Contrato.new
    end

    # GET /personas/1/edit
    def edit
      authorize! :update, Persona
      if @persona.status=='retirado'
        respond_to do |format|
            format.html { redirect_to @persona, alert: '<i class="fa fa-exclamation-triangle fa-lg"></i> El empleado esta retirado, no es posible editar los datos.' }
            format.json { head :no_content }
        end
      end

    end

    # POST /personas
    # POST /personas.json
    def create
          authorize! :create, Persona
        @persona = Persona.new(persona_params)

        respond_to do |format|
            if @persona.save


                @persona.cargo.save
                #  Cargo.where(id: params[:cargo_id]).update_all(disponible: false);
                format.html { redirect_to @persona, notice: '<i class="fa fa-check-square fa-lg"></i> La persona fue contratada exitosamente.' }
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

                format.html { redirect_to @persona, notice: '<i class="fa fa-check-square fa-lg"></i> Los datos del empleado fueron actualizados exitosamente.' }
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

        respond_to do |format|
            format.html { redirect_to personas_url, notice: '<i class="fa fa-check-square fa-lg"></i> El empleado fue despedido.' }
            format.json { head :no_content }
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_persona
      if(Persona.where(id: params[:id] ).length>0)
      @persona = Persona.find(params[:id])
      else
        respond_to do |format|
            format.html { redirect_to personas_url, alert: '<i class="fa fa-exclamation-triangle fa-lg"></i> Persona no encontrada en la base de datos.' }
          end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def persona_params
        params.require(:persona).permit(:cedula, :tipo_de_cedula, :cuenta, :FAOV, :TSS, :IVSS, :caja_de_ahorro, :nombres, :apellidos, :telefono_fijo, :telefono_movil, :avatar, :fecha_de_nacimiento, :correo, :direccion, :sexo, :cargo_id,
                                        registrosconceptos_attributes: [:id, :conceptopersonal_id, :modalidad_de_pago, :_destroy, formulaspersonales_attributes: [:id, :empleado, :patrono, :_destroy]],
                                        contrato_attributes: [:id, :fecha_inicio, :fecha_fin, :sueldo_externo, :tipo_de_contrato], familiares_attributes: [:id, :tipo_de_cedula, :cedula,:parentesco, :nombres, :apellidos, :fecha_de_nacimiento, :sexo, :direccion, :_destroy])
    end
end
