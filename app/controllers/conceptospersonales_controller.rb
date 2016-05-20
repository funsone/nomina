class ConceptospersonalesController < ApplicationController
  before_action :set_conceptopersonal, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_usuario!

  # GET /conceptospersonales
  # GET /conceptospersonales.json
  def index
    @conceptospersonales = Conceptopersonal.all
  end

  # GET /conceptospersonales/1
  # GET /conceptospersonales/1.json
  def show
    respond_to do |format|
        format.html

            
    end
  end

  # GET /conceptospersonales/new
  def new
    authorize! :create, Conceptopersonal
    @conceptopersonal = Conceptopersonal.new
  end

  # GET /conceptospersonales/1/edit
  def edit
    authorize! :update, Conceptopersonal
  end

  # POST /conceptospersonales
  # POST /conceptospersonales.json
  def create
    authorize! :create, Conceptopersonal
    @conceptopersonal = Conceptopersonal.new(conceptopersonal_params)

    respond_to do |format|
      if @conceptopersonal.save
        log("Se ha definido el concepto personal: #{@lt}", 0)

        format.html { redirect_to @conceptopersonal, notice: 'El concepto fue creado exitosamente.' }
        format.json { render :show, status: :created, location: @conceptopersonal }
      else
        format.html { render :new }
        format.json { render json: @conceptopersonal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /conceptospersonales/1
  # PATCH/PUT /conceptospersonales/1.json
  def update
    authorize! :update, Conceptopersonal
    respond_to do |format|
      if @conceptopersonal.update(conceptopersonal_params)
        log("Se ha actualizado el concepto personal: #{@lt}", 1)

        format.html { redirect_to @conceptopersonal, notice: 'Los datos del concepto fueron actualizados exitosamente.' }
        format.json { render :show, status: :ok, location: @conceptopersonal }
      else
        format.html { render :edit }
        format.json { render json: @conceptopersonal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conceptospersonales/1
  # DELETE /conceptospersonales/1.json
  def destroy
    authorize! :destroy, Conceptopersonal
    @conceptopersonal.destroy
    log("Se ha eliminado el concepto personal: #{@conceptopersonal.nombre}", 2)

    respond_to do |format|
      format.html { redirect_to conceptospersonales_url, notice: 'El concepto fue eliminado exitosamente.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_conceptopersonal
      if !Conceptopersonal.where(id: params[:id]).empty?
        @conceptopersonal = Conceptopersonal.find(params[:id])
        @lt = '<a href="' + conceptopersonal_path(@conceptopersonal) + '"> ' + @conceptopersonal.nombre + '</a>'
      else
        respond_to do |format|
          format.html { redirect_to conceptospersonales_url, alert: 'Concepto no encontrado en la base de datos.' }
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def conceptopersonal_params
      params.require(:conceptopersonal).permit(:nombre, :tipo_de_concepto)
    end
end
