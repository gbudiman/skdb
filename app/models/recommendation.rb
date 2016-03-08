class Recommendation < ActiveRecord::Base
  enum slot: [:weapon, :armor, :jewel]

  belongs_to :hero
  validates :hero, presence: true
end
