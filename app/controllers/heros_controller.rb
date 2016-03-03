class HerosController < ApplicationController
  def index
    log
    @preload = nil
    @compact_tabular = true
  end

  def index_mock
  end

  def index_fetch
    log
    render json: Hero.all
  end

  def view
  end

  def view_fetch
    log
    render json: Hero.details(params[:id])
  end

  def search
    log
    render json: Hero.search(params[:q])
  end

  def fetch_having_atb_effect
    log
    render json: Hero.fetch_having_atb_effect(effect: params[:e],
                                              target: params[:r])
  end

  def debug
    render json: Hero.details(Hero.where("name #{Utility.query_like} :n", n: "%#{params[:n]}%").ids)
  end

  def compare
    log
    @compact_tabular = true
    @preload = Array.new
    @url_friendly = Hash.new
    @mismatches = Array.new

    params[:ids].split(/\//).each do |e|
      case e
      when /\A\d+\z/ then @preload.push e.to_i
      else
        matches = Hero.where("static_name #{Utility.query_like} :name", name: "#{e}%")

        case matches.count
        when 0 then @mismatches.push e
        else 
          @preload.push matches.first.id
        end
      end
    end

    render :index
  end
end
