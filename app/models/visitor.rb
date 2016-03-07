class Visitor < ActiveRecord::Base
  after_initialize :set_default_date

  validates :address, presence: true, strict: ActiveRecord::StatementInvalid
  validates :todays_date, presence: true, strict: ActiveRecord::StatementInvalid

  def log
    existing = Visitor.find_or_initialize_by address: self.address, todays_date: self.todays_date

    if existing.id
      existing.todays_count += 1
    else
      existing.todays_count = 1
    end

    existing.save!
    self.id = existing.id
    return self
  end

  def self.log **_h
    Visitor.new(_h).log
  end

  def self.total_visit_by_country
    out = Hash.new
    result = Hash.new

    # Hash[Visitor.group(:address).sum(:todays_count).sort_by { |k, v| -v }.first(_limit)].each do |address, sum|
    #   country = IpCountry.seek_address(address)
    #   country_full_name = country ? country.country_full_name : '<< Unknown >>'
    #   h[address] = { country: country_full_name, sum: sum }
    # end

    ip_countries = Hash.new
    IpCountry.all.each do |r|
      ip_countries[r.address_start] = {
        address_end: r.address_end,
        country_id: r.country_id,
      }
    end

    addresses = Visitor.group(:address).sum(:todays_count)
    addresses.each do |_address, _sum|
      address = IpCountry.parse_integer _address

      ip_countries.select { |k, v| k < address and v[:address_end] > address }.each do |k, v|
        result[v[:country_id]] ||= 0
        result[v[:country_id]]  += _sum
      end
    end

    countries_lut = Hash.new

    Country.where(id: result.keys).each do |r|
      countries_lut[r.id] = r.long
    end

    result.keys.each do |k|
      out[countries_lut[k]] = result[k]
    end

    return Hash[out.sort_by { |k, v| -v }]
  end

private
  def set_default_date
    self.todays_date ||= Date.today
  end
end
