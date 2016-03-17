class TiersController < ApplicationController
  def index
    @full = true
  end

  def index_fetch
    log
    render json: Tier.fetch
  end
end
