class StatController < ApplicationController
	def index
		log
	end

	def index_fetch
		log
		render json: Hero.fetch_with_stats
	end

  # def index_fetch_update
  #   render json: Hero.fetch_with_stats(level: params[:level] ? params[:level].to_i : 30,
  #                                      plus: params[:plus] ? params[:plus].to_i : 0,
  #                                      update: true)
  # end
end
