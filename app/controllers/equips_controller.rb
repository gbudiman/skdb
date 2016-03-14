class EquipsController < ApplicationController
  def index
  end

  def index_fetch
    render json: Equip.fetch
  end
end
