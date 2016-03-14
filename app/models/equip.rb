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
    denorms = Array.new

    Equip.joins('LEFT OUTER JOIN equip_stats AS es
                   ON equips.id = es.equip_id')
         .select('equips.id AS id,
                  equips.name AS name,
                  equips.rank AS rank,
                  equips.slot AS slot,
                  equips.acquisition AS acquisition,
                  es.category AS category,
                  es.atb AS atb,
                  es.value AS value,
                  es.variance AS variance')
         .each do |r|
      result[r.id] ||= Hash.new
      result[r.id][:name] = r.name
      result[r.id][:rank] = r.rank
      result[r.id][:slot] = r.slot
      result[r.id][:acquisition] = r.acquisition

      result[r.id][:stats] ||= { fixed: Array.new, randomized: Array.new }

      if r.category
        category = EquipStat.categories.keys[r.category].to_sym

        maybe_variance = ''
        if r.variance
          maybe_variance = " ~ #{r.variance}"
        end
        result[r.id][:stats][category].push("#{r.atb} +#{r.value}#{maybe_variance}")

        if category == :fixed
          result[r.id][:stats][:fixed_sort] = "#{r.atb} #{sprintf('%012d', r.value)}"
        end
      end
    end

    result.each do |id, r|
      h = Hash.new
      h[:name] = r[:name]
      h[:rank] = r[:rank]
      h[:type] = r[:slot]
      h[:acquisition] = r[:acquisition]
      h[:fixed_stat] = r[:stats][:fixed]
      h[:fixed_sort] = r[:stats][:fixed_sort] || '_'
      h[:randomized_stat] = r[:stats][:randomized]

      denorms.push h
    end

    return denorms
  end

private
  def self.import!
    items = Hash.new

    RemoteTable.new('https://raw.githubusercontent.com/gbudiman/skdb/master/db/items.csv').each do |r|
      item = Equip.create! name: r['Item Name'],
                           rank: r['Rank'].to_i,
                           slot: r['Type'].to_sym,
                           acquisition: r['Acquisition'].strip.length == 0 ? nil : r['Acquisition'].strip

      main = EquipStat.create! equip_id: item.id,
                               category: :fixed,
                               atb: r['Stat_Main'],
                               value: r['Value_Main'],
                               variance: r['Var_Main'].strip.length == 0 ? nil : r['Var_Main'].strip

      (0..6).each do |i|
        next if r["Stat_#{i}"].strip.length == 0

        stat = r["Stat_#{i}"].strip
        val = r["Val_#{i}"].strip.length == 0 ? nil : r["Val_#{i}"].strip
        var = r["Var_#{i}"].strip.length == 0 ? nil : r["Var_#{i}"].strip

        rdm = EquipStat.create! equip_id: item.id,
                                category: :randomized,
                                atb: stat,
                                value: val,
                                variance: var
      end
    end
  end
end
