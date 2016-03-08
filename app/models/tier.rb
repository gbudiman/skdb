class Tier < ActiveRecord::Base
  enum category: [:adventure, 
                  :castle_rush_easy,
                  :castle_rush_normal,
                  :raid,
                  :arena,
                  :tower]

  belongs_to :hero
  validates :hero, presence: true
end
