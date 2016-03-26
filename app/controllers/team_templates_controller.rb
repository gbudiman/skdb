class TeamTemplatesController < ApplicationController
  def index
  end

  def index_fetch
    render json: TeamTemplate.fetch
  end
end
