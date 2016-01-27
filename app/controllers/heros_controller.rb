class HerosController < ApplicationController
  def index
  end

  def index_mock
  end

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
    render json: Hero.fetch_having_atb_effect(effect: params[:e],
                                              target: params[:r])
  end

  def debug
    render json: Hero.details(Hero.where('name LIKE :n', n: "%#{params[:n]}%").ids)
  end
end
