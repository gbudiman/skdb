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

  def self.fetch
    result = Hash.new

    Equip.joins('LEFT OUTER JOIN equip_stats AS es
                   ON equips.id = es.equip_id')
         .select('equips.id AS id,
                  equips.name AS name,
                  equips.rank AS rank,
                  equips.slot AS slot,
                  es.category AS category,
                  es.atb AS atb,
                  es.value AS value,
                  es.variance AS variance')
         .each do |r|
      result[id] ||= Hash.new
      result[id][:name] = r.name
      result[id][:rank] = r.rank
      result[id][:slot] = Equip.slots.keys[r.slot]
      result[id][:stats] ||= Hash.new
      
    end
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
