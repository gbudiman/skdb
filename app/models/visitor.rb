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

  def self.unique_visit_by_country
    h = Hash.new
    Visitor.group(:address).sum(:todays_count).each do |address, sum|
      country = IpCountry.seek_address(address)
      country_full_name = country ? country.country_full_name : '<< Unknown >>'
      h[address] = { country: country_full_name, sum: sum }
    end

    return h
  end

private
  def set_default_date
    self.todays_date ||= Date.today
  end
end
