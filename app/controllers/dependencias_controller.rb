class DependenciasController < ApplicationController
  before_filter :authenticate_usuario!

  before_action :set_dependencia, only: [:edit, :update, :destroy]

  # GET /dependencias
  # GET /dependencias.json
  def index
    @dependencias = Dependencia.all
  end

  # GET /dependencias/1
  # GET /dependencias/1.json
  def show
    respond_to do |format|
      format.html { redirect_to dependencias_path, alert: '<i class="fa fa-exclamation-triangle fa-lg"></i> Ruta no disponible.' }
    end
  end

  # GET /dependencias/new
  def new
    authorize! :create, Dependencia

    @dependencia = Dependencia.new
  end

  # GET /dependencias/1/edit
  def edit
    authorize! :update, Dependencia
  end

  # POST /dependencias
  # POST /dependencias.json
  def create
    authorize! :create, Dependencia
    @dependencia = Dependencia.new(dependencia_params)

    respond_to do |format|
      if @dependencia.save
        format.html { redirect_to dependencias_path, notice: '<i class="fa fa-check-square fa-lg"></i> La dependencia fue creada exitosamente.' }
        format.json { render :show, status: :created, location: @dependencia }
      else
        format.html { render :new }
        format.json { render json: @dependencia.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dependencias/1
  # PATCH/PUT /dependencias/1.json
  def update
    authorize! :update, Dependencia
    respond_to do |format|
      if @dependencia.update(dependencia_params)

        format.html { redirect_to dependencias_path, notice: '<i class="fa fa-check-square fa-lg"></i> Los datos de la dependencia fueron actualizados exitosamente.' }
        format.json { render :show, status: :ok, location: @dependencia }
      else
        format.html { render :edit }
        format.json { render json: @dependencia.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dependencias/1
  # DELETE /dependencias/1.json
  def destroy
    authorize! :destroy, Dependencia
    @dependencia.destroy

    respond_to do |format|
      format.html { redirect_to dependencias_url, notice: '<i class="fa fa-check-square fa-lg"></i> La dependencia fue eliminada exitosamente.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dependencia
      if !Dependencia.where(id: params[:id]).empty?
        @dependencia = Dependencia.find(params[:id])
      else
        respond_to do |format|
          format.html { redirect_to dependencias_url, alert: '<i class="fa fa-exclamation-triangle fa-lg"></i> Dependencia no encontrada en la base de datos.' }
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dependencia_params
      params.require(:dependencia).permit(:nombre)
    end
end
