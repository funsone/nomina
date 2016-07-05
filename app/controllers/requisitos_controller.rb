class RequisitosController < ApplicationController
  before_filter :authenticate_usuario!

  before_action :set_requisito, only: [:edit, :update, :destroy]

  # GET /requisitos
  # GET /requisitos.json
  def index
    @requisitos = Requisito.all
  end

  # GET /requisitos/1
  # GET /requisitos/1.json
  def show
    respond_to do |format|
      format.html { redirect_to requisitos_path, alert: '<i class="fa fa-exclamation-triangle fa-lg"></i> Ruta no disponible.' }
    end
  end

  # GET /requisitos/new
  def new
    authorize! :create, Dependencia
    @requisito = Requisito.new
  end

  # GET /requisitos/1/edit
  def edit
    authorize! :update, Dependencia
  end

  # POST /requisitos
  # POST /requisitos.json
  def create
    authorize! :create, Dependencia
    @requisito = Requisito.new(requisito_params)

    respond_to do |format|
      if @requisito.save
        format.html { redirect_to requisitos_path, notice: '<i class="fa fa-check-square fa-lg"></i> El requisito fue creado exitosamente.' }
        format.json { render :show, status: :created, location: @requisito }
      else
        format.html { render :new }
        format.json { render json: @requisito.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /requisitos/1
  # PATCH/PUT /requisitos/1.json
  def update
    authorize! :update, Dependencia
    respond_to do |format|
      if @requisito.update(requisito_params)
        format.html { redirect_to requisitos_path, notice: '<i class="fa fa-check-square fa-lg"></i> Los datos del requisito fueron actualizados exitosamente.' }
        format.json { render :show, status: :ok, location: @requisito }
      else
        format.html { render :edit }
        format.json { render json: @requisito.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /requisitos/1
  # DELETE /requisitos/1.json
  def destroy
    @requisito.destroy
    respond_to do |format|
      format.html { redirect_to requisitos_url, notice: '<i class="fa fa-check-square fa-lg"></i>El requisito fue eliminado exitosamente.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_requisito
      @requisito = Requisito.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def requisito_params
      params.require(:requisito).permit(:nombre)
    end
end
