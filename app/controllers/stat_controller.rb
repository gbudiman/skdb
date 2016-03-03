class StatController < ApplicationController
	def index
	end

	def index_fetch
		render json: Hero.fetch_with_stats
	end
end
