class XlsxInterface
  attr_reader :skills, :stats

  def initialize _path
    @skills = process_skill RemoteTable.new(_path, sheet: 'skills')
    @stats = process_stat RemoteTable.new(_path, sheet: 'stats')

    return self
  end

  def self.mock_test
    data = Importer.new(_load_xlsx :mock)
  end

  def self.update_database!
    Utility.shut_up do
      data = Importer.new(_load_xlsx :real_shit)
      data.commit!
    end
  end

  def self.rebuild_database!
    Utility.shut_up do
      Hero.destroy_all
      Atb.destroy_all
      update_database!
    end
  end

private
  def self._load_xlsx _type
    xlsx = case _type
    when :mock then XlsxInterface.new(Rails.root.join('spec', 'xlsx', 'test.xlsx').to_s)
    else            XlsxInterface.new(Rails.root.join('db', 'seed.xlsx').to_s)
    end

    return xlsx
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
end
