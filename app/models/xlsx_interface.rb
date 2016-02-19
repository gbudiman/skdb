class XlsxInterface
  attr_reader :result

  def initialize _path
    raw_data = RemoteTable.new(_path, sheet: 'data')
    @result = process raw_data

    return self
  end

  def self.mock_test
    xlsx = XlsxInterface.new(Rails.root.join('spec', 'xlsx', 'test.xlsx').to_s)
    data = Importer.new(xlsx.result)
  end

  def self.update_database!
    Utility.shut_up do
      xlsx = XlsxInterface.new(Rails.root.join('db', 'seed.xlsx').to_s)
      data = Importer.new(xlsx.result)
      data.commit!
    end
  end

  def self.rebuild_database!
    Utility.shut_up do
      Atb.destroy_all
      update_database!
    end
  end



private
  def process _d
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
end
