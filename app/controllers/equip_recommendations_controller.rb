class EquipRecommendationsController < ApplicationController
	def index
		@jewel_columns = Recommendation.fetch_jewel_types
	end

	def index_fetch
    log
		render json: Hero.fetch_equip_recommendations
	end
end
