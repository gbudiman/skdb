class VisitorController < ApplicationController
  def stats_fetch
    s = Hash.new
    s[:unique_visit_count] = Visitor.group(:todays_date).count(:address)
    s[:total_visit_count] = Visitor.group(:todays_date).sum(:todays_count)
    s[:most_active] = Hash[Visitor.group(:address).sum(:todays_count).sort_by { |k, v| -v }.first(32)]
    s[:unique_visit_to_date] = Visitor.distinct(:address).count(:address)
    s[:total_visit_to_date] = Visitor.sum(:todays_count)

    render json: s
  end
end
