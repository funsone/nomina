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
  end

  # GET /conceptospersonales/new
  def new
    @conceptopersonal = Conceptopersonal.new
  end

  # GET /conceptospersonales/1/edit
  def edit
  end

  # POST /conceptospersonales
  # POST /conceptospersonales.json
  def create
    @conceptopersonal = Conceptopersonal.new(conceptopersonal_params)

    respond_to do |format|
      if @conceptopersonal.save
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
    respond_to do |format|
      if @conceptopersonal.update(conceptopersonal_params)
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
    @conceptopersonal.destroy
    respond_to do |format|
      format.html { redirect_to conceptospersonales_url, notice: 'El concepto fue eliminado exitosamente.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_conceptopersonal
      @conceptopersonal = Conceptopersonal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def conceptopersonal_params
      params.require(:conceptopersonal).permit(:nombre, :tipo_de_concepto)
    end
end
