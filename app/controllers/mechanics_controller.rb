class MechanicsController < ApplicationController
  def status_effects_fetch
    render json: Atb.get_status_effects
  end
end
