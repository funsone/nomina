class DependenciasController < ApplicationController
  before_action :set_dependencia, only: [:show, :edit, :update, :destroy]

  # GET /dependencias
  # GET /dependencias.json
  def index
    @dependencias = Dependencia.all
  end

  # GET /dependencias/1
  # GET /dependencias/1.json
  def show
  end

  # GET /dependencias/new
  def new
    @dependencia = Dependencia.new
  end

  # GET /dependencias/1/edit
  def edit
  end

  # POST /dependencias
  # POST /dependencias.json
  def create
    @dependencia = Dependencia.new(dependencia_params)

    respond_to do |format|
      if @dependencia.save
        format.html { redirect_to @dependencia, notice: 'Dependencia was successfully created.' }
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
    respond_to do |format|
      if @dependencia.update(dependencia_params)
        format.html { redirect_to @dependencia, notice: 'Dependencia was successfully updated.' }
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
    @dependencia.destroy
    respond_to do |format|
      format.html { redirect_to dependencias_url, notice: 'Dependencia was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dependencia
      @dependencia = Dependencia.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dependencia_params
      params.require(:dependencia).permit(:nombre)
    end
end