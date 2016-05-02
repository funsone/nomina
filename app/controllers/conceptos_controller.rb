class ConceptosController < ApplicationController
  before_filter :authenticate_usuario!

  before_action :set_concepto, only: [:show, :edit, :update, :destroy]

  # GET /conceptos
  # GET /conceptos.json
  def index
    @conceptos = Concepto.all
  end

  # GET /conceptos/1
  # GET /conceptos/1.json
  def show
  end

  # GET /conceptos/new
  def new
    @concepto = Concepto.new
  end

  # GET /conceptos/1/edit
  def edit
  end

  # POST /conceptos
  # POST /conceptos.json
  def create
    if params[:concepto][:tipo_ids]
      params[:concepto][:tipo_ids] = params[:concepto][:tipo_ids].map{|k, v| k}
    else
      params[:concepto][:tipo_ids] = []
    end

    @concepto = Concepto.new(concepto_params)

    respond_to do |format|
      if @concepto.save
        log("Se ha creado el concepto: #{@concepto.nombre}", 1)

        format.html { redirect_to @concepto, notice: 'El concepto fue creado exitosamente.' }
        format.json { render :show, status: :created, location: @concepto }
      else
        format.html { render :new }
        format.json { render json: @concepto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /conceptos/1
  # PATCH/PUT /conceptos/1.json
  def update
    if params[:concepto][:tipo_ids]
      params[:concepto][:tipo_ids] = params[:concepto][:tipo_ids].map{|k, v| k}
    else
      params[:concepto][:tipo_ids] = []
    end
    respond_to do |format|
      if @concepto.update(concepto_params)
        log("Se ha actualizado el concepto: #{@concepto.nombre}", 1)

        format.html { redirect_to @concepto, notice: 'Los datos del concepto fueron actualizados exitosamente.' }
        format.json { render :show, status: :ok, location: @concepto }
      else
        format.html { render :edit }    if params[:concepto][:tipo_ids]
        format.json { render json: @concepto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conceptos/1
  # DELETE /conceptos/1.json
  def destroy
    @concepto.destroy
    log("Se ha eliminado el concepto: #{@concepto.nombre}", 1)

    respond_to do |format|
      format.html { redirect_to conceptos_url, notice: 'El concepto fue eliminado exitosamente.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_concepto
      @concepto = Concepto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def concepto_params
      params.require(:concepto).permit(:nombre, :formula, :modalidad_de_pago, :tipo_de_concepto, :formula_patrono, :condicion, tipo_ids: [])
    end
end
