class IpCountry < ActiveRecord::Base
  belongs_to :country
  validates :country, presence: true

  def self.seek_address _s
    quads = _s.split(/\./)
    x = 0
    quads.reverse.each_with_index do |q, i|
      x += q.to_i * (0x100**i)
    end

    IpCountry.joins(:country)
             .select('countries.long AS country_full_name')
             .find_by('address_start < :x AND address_end > :x', x: x)

  end

  def self.parse_integer _s
    quads = _s.split(/\./)
    x = 0
    quads.reverse.each_with_index do |q, i|
      x += q.to_i * (0x100**i)
    end

    return x
  end

  def self.to_quad _i
    x = _i
    quads = Array.new
    4.times do |i|
      quads.push(sprintf("%02X", x & 0xFF))
      x = x >> 8
    end

    return quads.reverse.join('.')
  end

  def self._test_parse_address
    result = Hash.new

    IpCountry.joins(:country).select('countries.long AS country_full_name, 
                                      address_start,
                                      address_end').each do |c|
      # puts "#{IpCountry.to_quad c.address_start} -> #{IpCountry.to_quad c.address_end}: #{c.country_full_name}"
      result[IpCountry.to_quad c.address_start] = { end_address: IpCountry.to_quad(c.address_end),
                                                    country: c.country_full_name,
                                                    numeric: c.address_start }
    end

    result.sort_by{ |k, v| v[:numeric] }.each do |start_address, d|
      puts "#{start_address} -> #{d[:end_address]}: #{d[:country]}"
    end
  end

  def self.rebuild_database!
    addresses = Hash.new
    countries = Hash.new
    File.open(Rails.root.join('db', 'ip_to_country.csv')) do |f|
      f.each_line do |l|
        next if l[0] == '#'

        cells = l.gsub(/\n/, '').split(/\,/)
        start_address = cells[0].gsub(/\"/, '').to_i
        end_address = cells[1].gsub(/\"/, '').to_i
        country_2 = cells[-3].gsub(/\"/, '')
        country_3 = cells[-2].gsub(/\"/, '')
        country_full = cells[-1].gsub(/\"/, '')

        countries[country_2] ||= {
          country_3: country_3,
          country_full: country_full
        }

        addresses[start_address] = {
          end_address: end_address,
          country_2: country_2
        }
      end
    end

    Utility.shut_up do
      ActiveRecord::Base.transaction do
        IpCountry.delete_all
        Country.delete_all

        countries.each do |key, data|
          Country.create! short: key, mid: data[:country_3], long: data[:country_full]
        end
      end


      country_lut = Hash.new

      Country.all.each do |r|
        country_lut[r.short] = r.id
      end

      inserts = Array.new
      addresses.each_with_index do |(start, data), i|
        puts "#{i} processed..." if i % 10000 == 0
        #country = Country.find_by short: data[:country_2]
        country_id = country_lut[data[:country_2]]
        # IpCountry.create! address_start: start,
        #                   address_end: data[:end_address],
        #                   country_id: country.id
        inserts.push "(#{start}, #{data[:end_address]}, #{country_id})"
      end

      inserts.each_slice(4096) do |slice|
        sql = "INSERT INTO ip_countries(address_start, address_end, country_id) VALUES #{slice.join(',')}"
        ActiveRecord::Base.connection.execute(sql)
      end
      
    end

    puts "#{Country.count} country entries created"
    puts "#{IpCountry.count} IP address range entries created"
  end
end
