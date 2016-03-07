class CouponsController < ApplicationController
  def index
  end

  def index_fetch
    log
    render json: Coupon.all
  end
end
