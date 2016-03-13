class Equip < ActiveRecord::Base
  enum slot: [:phy_weapon, :mag_weapon, :armor, :jewel]

  has_many :equip_stats, dependent: :destroy

  def self.rebuild_database!
    ActiveRecord::Base.transaction do
      Utility.shut_up do
        Equip.destroy_all

        import!
      end
    end
  end

private
  def self.import!
    items = Hash.new

    RemoteTable.new('https://raw.githubusercontent.com/gbudiman/skdb/master/db/items.csv').each do |r|
      # Item.find_or_initialize_by name:
      #                            rank:
      #                            slot:
    end
  end
end
