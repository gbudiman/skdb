class Visitor < ActiveRecord::Base
  validates :address, presence: true, strict: ActiveRecord::StatementInvalid
  validate :set_default_date

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

private
  def set_default_date
    self.todays_date ||= Date.today
  end
end
