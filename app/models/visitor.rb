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

    # ip_countries = Hash.new
    # IpCountry.all.each do |r|
    #   ip_countries[r.address_start] = {
    #     address_end: r.address_end,
    #     country_id: r.country_id,
    #   }
    # end


    # addresses = Visitor.group(:address).sum(:todays_count)
    # addresses.each do |_address, _sum|
    #   address = IpCountry.parse_integer _address

    #   ip_countries.select { |k, v| k < address and v[:address_end] > address }.each do |k, v|
    #     result[v[:country_id]] ||= 0
    #     result[v[:country_id]]  += _sum
    #   end
    # end

    # countries_lut = Hash.new

    # Country.where(id: result.keys).each do |r|
    #   countries_lut[r.id] = r.long
    # end

    # result.keys.each do |k|
    #   out[countries_lut[k]] = result[k]
    # end

    return Hash[out.sort_by { |k, v| -v }]
  end

  def self.summarize_and_destroy_records!
    # Summarize everything up to last week
    date_limit = Date.today - 7 
    data = Hash.new

    Visitor.where('todays_date < :d', d: date_limit).each do |r|
      data[r.todays_date] ||= { count: 0, cumulative: 0 }
      data[r.todays_date][:count] += 1
      data[r.todays_date][:cumulative] += r.todays_count
    end

    ActiveRecord::Base.transaction do
      data.each do |k, v|
        sv = SummarizedVisitor.find_or_initialize_by todays_date: k
        sv.visit_count ||= 0
        sv.visit_count  += v[:cumulative]

        sv.unique_count ||= 0
        sv.unique_count  += v[:count]
        sv.save!
      end

      Visitor.where(todays_date: data.keys).destroy_all
    end

    return data.keys.count
  end

private
  def set_default_date
    self.todays_date ||= Date.today
  end
end
