class TeamTemplatesController < ApplicationController
  def index
    @data = TeamTemplate.fetch
  end

  def index_fetch
    render json: TeamTemplate.fetch
  end
end
