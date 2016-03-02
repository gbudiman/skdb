class Stat < ActiveRecord::Base
  enum name: [ :hp, :atk, :mag, :def, :spd ]
  enum datapoint: [ :thirty, :forty, :forty_5 ]

  validates :value, 
            numericality: { only_integer: true, 
                            greater_than: 0 }, 
            strict: ActiveRecord::StatementInvalid

  belongs_to :hero
  validates :hero, presence: true, strict: ActiveRecord::StatementInvalid

  def save_or_update
    s = Stat.find_or_initialize_by name: Stat.names[self.name],
                                   datapoint: Stat.datapoints[self.datapoint],
                                   hero_id: self.hero_id

    if s.id != nil
      s.update value: self.value
      self.id = s.id
    else
      self.save
    end
  end

  def self.save_or_update **_h
    s = Stat.new _h
    s.save_or_update
  end
end
