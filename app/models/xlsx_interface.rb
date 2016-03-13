class XlsxInterface
  attr_reader :skills, :stats, :atbs

  def initialize _path
    @skills = process_skill RemoteTable.new(_path, sheet: 'skills')
    @stats = process_stat RemoteTable.new(_path, sheet: 'stats')
    @atbs = RemoteTable.new(_path, sheet: 'attributes')

    return self
  end

  def self.mock_test
    data = Importer.new(_load_xlsx :mock)
  end

  def self.update_database! **_h
    Utility.shut_up do
      if _h[:remote]
        data = Importer.new(_load_xlsx :remote)
      else
        data = Importer.new(_load_xlsx :real_shit)
      end

      data.commit!
    end
  end

  def self.rebuild_database! **_h
    Utility.shut_up do
      Hero.destroy_all
      Atb.destroy_all
      Recommendation.destroy_all
      Tier.destroy_all
      update_database! _h
    end
  end

private
  def self._load_xlsx _type
    xlsx = case _type
    when :mock    then XlsxInterface.new(Rails.root.join('spec', 'xlsx', 'test.xlsx').to_s)
    when :remote  then XlsxInterface.new('https://github.com/gbudiman/skdb/raw/master/db/seed.xlsx')
    else               XlsxInterface.new(Rails.root.join('db', 'seed.xlsx').to_s)
    end

    return xlsx
  end

  def process_atb _d
    _d.each do |row|
    end
  end

  def process_skill _d
    result = Array.new

    _d.each do |row|
      h = { static_data:    row['Static Data'],
            hero_name:      row['Hero'],
            skill_name:     row['Skill'],
            cooldown:       (row['Cooldown'] || 0).to_i,
            attributes:     Array.new }

      row.keys[4..-1].each_slice(3) do |s|
        unless row[s[0]].blank?
          value = case row[s[2]]
          when /[A-Za-z]/
            row[s[2]].to_sym
          else
            row[s[2]].to_i
          end

          h[:attributes].push({ name: row[s[0]].to_sym,
                                target: row[s[1]].to_sym,
                                value: value 
                             })
        end
      end

      result.push h
    end

    return result
  end

  def process_stat _d
    result = Array.new

    _d.each do |row|
      has_data = !row['Type'].blank?
      type = has_data ? row['Type'].downcase.to_sym : nil
      raise RuntimeError, 'Hero\'s attack type must either be :phy or :mag' if has_data and not [:phy, :mag].include? type

      h = { static_data:    row['Static Name'],
            type:           type,
            spd:            nbti(row['SPD']),
            element:        row['element'],
            category:       row['class'],
            datapoints: {
              thirty:         { hp: nbti(row['HP_thirty']),
                                atk: nbti(row['ATK_thirty']),
                                def: nbti(row['DEF_thirty'])
                              },
              forty:          { hp: nbti(row['HP_forty']),
                                atk: nbti(row['ATK_forty']),
                                def: nbti(row['DEF_forty'])
                              },
              forty_5:        { hp: nbti(row['HP_forty_5']),
                                atk: nbti(row['ATK_forty_5']),
                                def: nbti(row['DEF_forty_5'])
                              },
            },
            equip_recommendations: {
              weapon: nbts(row['rec_weapon']),
              armor:  nbts(row['rec_armor']),
              jewel:  nbta(row['rec_jewel_0'], row['rec_jewel_1'], row['rec_jewel_2'])
            },
            tiers: {
              adventure: nbts(row['t_adv']),
              cr_easy:   nbts(row['t_ecr']),
              cr_normal: nbts(row['t_ncr']),
              pvp:       nbts(row['t_pvp']),
              tower:     nbts(row['t_tower']),
              raid:      nbts(row['t_raid']),
              boss:      nbts(row['t_boss'])
            }
          }

      result.push h
    end

    return result
  end

  def nbti _x
    # Not blank? Convert to integer
    return _x.blank? ? nil : _x.to_i
  end

  def nbts _x
    return _x.length == 0 ? nil : _x
  end

  def nbta *_a
    content = Array.new
    _a.each { |x| (x != nil and x.strip.length > 0) ? content.push(x.strip) : 0 }

    return content.length > 0 ? content.sort.join(', ') : nil
  end
end
