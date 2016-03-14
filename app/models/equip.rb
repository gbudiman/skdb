class Equip < ActiveRecord::Base
  enum slot: [:phy_weapon, :mag_weapon, :armor, :jewel, :misc]

  has_many :equip_stats, dependent: :destroy

  def self.rebuild_database!
    ActiveRecord::Base.transaction do
      Utility.shut_up do
        Equip.destroy_all

        import!
      end
    end

    puts "#{Equip.count} items recorded"
    puts "#{EquipStat.count} item attributes recorded"
  end

private
  def self.import!
    items = Hash.new

    RemoteTable.new('https://raw.githubusercontent.com/gbudiman/skdb/master/db/items.csv').each do |r|
      item = Equip.create! name: r['Item Name'],
                          rank: r['Rank'].to_i,
                          slot: r['Type'].to_sym

      main = EquipStat.create! equip_id: item.id,
                               category: :fixed,
                               atb: r['Stat_Main'],
                               value: r['Value_Main'],
                               variance: r['Var_Main'].strip.length == 0 ? nil : r['Var_Main'].strip


      puts r['Item Name']
      (0..6).each do |i|
        next if r["Stat_#{i}"].strip.length == 0

        stat = r["Stat_#{i}"].strip
        val = r["Val_#{i}"].strip.length == 0 ? nil : r["Val_#{i}"].strip
        var = r["Var_#{i}"].strip.length == 0 ? nil : r["Val_#{i}"].strip

        rdm = EquipStat.create! equip_id: item.id,
                                category: :randomized,
                                atb: stat,
                                value: val,
                                variance: var
      end
    end
  end
end
