class HerosController < ApplicationController
  def index_fetch
    render json: Hero.all
  end

  def view
  end

  def view_fetch
    render json: Hero.details(params[:id])
  end
end
