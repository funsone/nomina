class WelcomeController < ApplicationController
  before_filter :authenticate_usuario!, only: [:index]

  def index
  end
  def ayuda
  end
end
