class DepartamentosController < ApplicationController
  before_filter :authenticate_usuario!

  before_action :set_departamento, only: [:show, :edit, :update, :destroy]

  # GET /departamentos
  # GET /departamentos.json
  def index
    @departamentos = Departamento.all
  end

  # GET /departamentos/1
  # GET /departamentos/1.json
  def show
  end

  # GET /departamentos/new
  def new
    authorize! :create, Departamento
    if Dependencia.all.length <=0
    respond_to do |format|
      format.html { redirect_to dependencias_url, notice: 'Es necesario agregar dependencia.'  }
      format.json { render json: @persona.errors, status: "Es necesario agregar dependencia." }
    end
  else
    @departamento = Departamento.new
    end
  end

  # GET /departamentos/1/edit
  def edit
    authorize! :update, Departamento
  end

  # POST /departamentos
  # POST /departamentos.json
  def create
    authorize! :create, Departamento
    @departamento = Departamento.new(departamento_params)

    respond_to do |format|
      if @departamento.save
        log("Se a creado el departamento #{@lt}", 0)
        format.html { redirect_to @departamento, notice: 'El departamento fue creado exitosamente.' }
        format.json { render :show, status: :created, location: @departamento }
      else
        format.html { render :new }
        format.json { render json: @departamento.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /departamentos/1
  # PATCH/PUT /departamentos/1.json
  def update
    authorize! :update, Departamento
    respond_to do |format|
      if @departamento.update(departamento_params)
        log("Se ha editado el departamento #{@lt}", 1)
        format.html { redirect_to @departamento, notice: 'Los datos del departamento fueron actualizados exitosamente.' }
        format.json { render :show, status: :ok, location: @departamento }
      else
        format.html { render :edit }
        format.json { render json: @departamento.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /departamentos/1
  # DELETE /departamentos/1.json
  def destroy
    authorize! :destroy, Departamento
    @departamento.destroy
    log("Se ha eliminado el departamento #{@departamento.nombre}", 2)
    respond_to do |format|
      format.html { redirect_to departamentos_url, notice: 'El departamento fue eliminado exitosamente.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_departamento
      if !Departamento.where(id: params[:id]).empty?
        @departamento= Departamento.find(params[:id])
        @lt = '<a href="' + departamento_path(@departamento) + '"> ' + @departamento.nombre + '</a>'
      else
        respond_to do |format|
          format.html { redirect_to departamentos_url, alert: 'Departamento no encontrado en la base de datos.' }
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def departamento_params
      params.require(:departamento).permit(:nombre, :dependencia_id)
    end
end
