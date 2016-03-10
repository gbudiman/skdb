class TiersController < ApplicationController
  def index
  end

  def index_fetch
    render json: Tier.fetch
  end
end
