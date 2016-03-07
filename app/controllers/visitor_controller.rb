class VisitorController < ApplicationController
  def stats_fetch
    s = Hash.new
    s[:unique_visit_count] = Visitor.group(:todays_date).order(todays_date: :desc).limit(16).count(:address)
    s[:total_visit_count] = Visitor.group(:todays_date).order(todays_date: :desc).limit(16).sum(:todays_count)
    s[:most_active] = Hash[Visitor.group(:address).sum(:todays_count).sort_by { |k, v| -v }.first(16)]
    s[:unique_visit_to_date] = Visitor.distinct(:address).count(:address)
    s[:total_visit_to_date] = Visitor.sum(:todays_count)
    s[:total_visit_by_country] = Visitor.unique_visit_by_country

    render json: s
  end
end
