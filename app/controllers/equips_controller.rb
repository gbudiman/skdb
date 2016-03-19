class EquipsController < ApplicationController
  def index
  end

  def index_fetch
    log
    render json: Equip.fetch
  end
end
