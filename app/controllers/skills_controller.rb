class SkillsController < ApplicationController
  def search
    render json: Skill.search(params[:q])
  end
end
