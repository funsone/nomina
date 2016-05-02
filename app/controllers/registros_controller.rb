class RegistrosController < ApplicationController
  before_filter :authenticate_usuario!
  before_action :redir, only: [:show, :edit, :update,:new]

  # GET /registros
  # GET /registros.json
  def index
    p = params[:page]
    @registros = Registro.order("created_at DESC").paginate(page: p)
  end
  def destroy
    Registro.destroy_all
    respond_to do |format|
      format.html { redirect_to registros_url, notice: 'Registro limpiado exitosamente.' }
      format.json { head :no_content }
    end
  end
  # GET /registros/1
  # GET /registros/1.json
  def show
    respond_to do |format|
      format.html { redirect_to registros_url}
      format.json { head :no_content }
    end
  end

  # GET /registros/new
  def new

  end

  # GET /registros/1/edit
  def edit
  end

  # POST /registros
  # POST /registros.json
  def create
  end

  # PATCH/PUT /registros/1
  # PATCH/PUT /registros/1.json
  def update
  end
private
def redir
  respond_to do |format|
    format.html { redirect_to registros_url}
    format.json { head :no_content }
  end
end
  # DELETE /registros/1
  # DELETE /registros/1.json

end
