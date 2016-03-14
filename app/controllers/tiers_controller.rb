class TiersController < ApplicationController
  def index
    @full = true
  end

  def index_fetch
    render json: Tier.fetch
  end
end
