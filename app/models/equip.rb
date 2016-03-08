class Equip < ActiveRecord::Base
  enum slot: [:phy_weapon, :mag_weapon, :armor, :jewel]

  has_many :equip_stats, dependent: :destroy
end
