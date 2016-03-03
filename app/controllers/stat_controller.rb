class StatController < ApplicationController
	def index
		log
	end

	def index_fetch
		render json: Hero.fetch_with_stats
	end
end
