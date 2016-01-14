class AtbsController < ApplicationController
  def search
    render json: Atb.search(params[:q])
  end
end
