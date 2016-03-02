class VisitorController < ApplicationController
  def stats_fetch
    s = Hash.new
    s[:unique_visit_count] = Visitor.group(:todays_date).count(:address)
    s[:total_visit_count] = Visitor.group(:todays_date).sum(:todays_count)
    s[:most_active] = Hash[Visitor.group(:address).sum(:todays_count).sort_by { |k, v| -v }.first(32)]

    render json: s
  end
end
