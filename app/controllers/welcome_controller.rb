class WelcomeController < ApplicationController
  before_filter :authenticate_usuario!, only: [:index,:users]

  def index
  end
  def ayuda
  end
  def users
    authorize! :read, Usuario
    @usuarios=Usuario.all
  end
end
