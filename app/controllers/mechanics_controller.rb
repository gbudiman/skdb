class MechanicsController < ApplicationController
  def index
    log
  end
  
  def status_effects_fetch
    render json: Atb.get_status_effects
  end

  def stat_modifiers_fetch
    render json: Atb.get_stat_modifiers
  end
end
