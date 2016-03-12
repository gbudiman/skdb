class Recommendation < ActiveRecord::Base
  enum slot: [:weapon, :armor, :jewel]

  belongs_to :hero
  validates :hero, presence: true

  def self.fetch_jewel_types
    jewels = Array.new
    Recommendation.all.where(slot: Recommendation.slots[:jewel]).pluck(:value).each do |j|
      j.split(/\, /).each do |je|
        jewels.push je
      end
    end

    return jewels.uniq.sort
  end
end
