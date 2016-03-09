class RecommendationAddDeviation < ActiveRecord::Migration
  def change
  	add_column       :recommendations, :deviation, :boolean, default: false
  end
end
