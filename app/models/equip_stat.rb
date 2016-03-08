class EquipStat < ActiveRecord::Base
  belongs_to :equip
  validates :equip, presence: true

  enum category: [:fixed, :randomized]
end
