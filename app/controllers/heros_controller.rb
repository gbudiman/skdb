class HerosController < ApplicationController
  def index_fetch
    render json: Hero.all
  end

  def view
  end

  def view_fetch
    render json: Hero.details(params[:id])
  end

  def search
    render json: Hero.search(params[:q])
  end

  def fetch_having_atb_effect
    render json: Hero.fetch_having_atb_effect(params[:n])
  end
end
