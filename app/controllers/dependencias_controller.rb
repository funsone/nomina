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
      format.html { redirect_to dependencias_path, notice: 'Ruta no disponible.' }
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
        log("Se ha creado la dependencia #{@lt}", 0)
        format.html { redirect_to dependencias_path, notice: 'La dependencia fue creada exitosamente.' }
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
        log("Se ha editado la dependencia #{@lt}", 1)
        format.html { redirect_to dependencias_path, notice: 'Los datos de la dependencia fueron actualizados exitosamente.' }
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
            log("Se ha eliminado la dependencia #{@dependencia.nombre}", 2)
    respond_to do |format|
      format.html { redirect_to dependencias_url, notice: 'La dependencia fue eliminada exitosamente.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dependencia
      if !Dependencia.where(id: params[:id]).empty?
        @dependencia = Dependencia.find(params[:id])
        @lt = '<a href="' + dependencias_path + '"> ' + @dependencia.nombre + '</a>'
      else
        respond_to do |format|
          format.html { redirect_to dependencias_url, alert: 'Dependencia no encontrada en la base de datos.' }
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dependencia_params
      params.require(:dependencia).permit(:nombre)
    end
end
