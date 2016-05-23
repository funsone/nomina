class TiposController < ApplicationController
  before_action :set_tipo, only: [:show, :edit, :update, :destroy]

  # GET /tipos
  # GET /tipos.json
  def index
    @tipos = Tipo.all
  end

  # GET /tipos/1
  # GET /tipos/1.json
  def show
    respond_to do |format|
      format.html { redirect_to tipos_path, notice: 'Ruta no disponible.' }
      format.json
      format.pdf do
        case params[:doc]
        when '0'
          pdf = RecibosPdf.new(@tipo, 0, params[:c],params[:cp])
          file = "Recibos_#{@tipo.nombre}"
        when '1'
          pdf = RecibosPdf.new(@tipo, 1, params[:c],params[:cp])
          file = "Recibos_#{@tipo.nombre}_ECO"
        when '2'
          pdf = BancariosPdf.new(@tipo, 0)
          file = "Bancarios_#{@tipo.nombre}"
        when '3'
          pdf = BancariosPdf.new(@tipo, 1)
          file = "Bancarios_#{@tipo.nombre}_ECO"
        when '4'
          pdf = ConceptosPdf.new(@tipo, 0, params[:c],params[:cp])
          file = "Conceptos_#{@tipo.nombre}"
        when '5'
          pdf = ConceptosPdf.new(@tipo, 1, params[:c],params[:cp])
          file = "Conceptos_#{@tipo.nombre}_ECO"
        end
        send_data pdf.render, filename: file, type: 'application/pdf', disposition: 'inline'
      end
    end
  end

  # GET /tipos/new
  def new
    authorize! :create, Tipo
    @tipo = Tipo.new
  end

  # GET /tipos/1/edit
  def edit
    authorize! :update, Tipo
  end

  # POST /tipos
  # POST /tipos.json
  def create
    authorize! :create, Tipo
    @tipo = Tipo.new(tipo_params)
    log("Se ha creado la nomina #{@lt}", 0)

    respond_to do |format|
      if @tipo.save
        format.html { redirect_to tipos_path, notice: 'La nómina fue creada exitosamente.' }
        format.json { render :show, status: :created, location: @tipo }
      else
        format.html { render :new }
        format.json { render json: @tipo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tipos/1
  # PATCH/PUT /tipos/1.json
  def update
    authorize! :update, Tipo
    respond_to do |format|
      if @tipo.update(tipo_params)
        log("Se ha editado la nomina #{@lt}", 1)
        format.html { redirect_to tipos_path, notice: 'Los datos de la nómina fueron actualizados exitosamente.' }
        format.json { head :no_content }
      end
    end
  end

  def destroy
    authorize! :destroy, Tipo
    @tipo.destroy
            log("Se ha eliminado la nomina #{@tipo.nombre}", 2)
    respond_to do |format|
      format.html { redirect_to tipos_url, notice: 'La nómina fue eliminada exitosamente.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tipo
    if(Tipo.where(id: params[:id] ).length>0)
    @tipo = Tipo.find(params[:id])
      @lt= '<a href="'+tipos_path+'"> '+@tipo.nombre+'</a>'
    else
      respond_to do |format|
          format.html { redirect_to tipos_url, alert: 'Nomina no encontrada en la base de datos.' }
      end
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tipo_params
    params.require(:tipo).permit(:nombre)
  end
end
