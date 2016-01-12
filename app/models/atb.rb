class Atb < ActiveRecord::Base
  enum category: [ :direct_attack,
                   :mechanics,
                   :healing,
                   :immunities,
                   :debuffs,
                   :revivals,
                   :stat_modifiers]
  enum modifier: [ :fraction, :amount, :turns, :probability, :hit_count ]

  before_validation :parse

  validates :name, :modifier, presence: true, strict: ActiveRecord::StatementInvalid

  has_many :skill_atbs, dependent: :destroy

  def parse
    self.modifier = \
      case self.name
      when /(fraction|amount|turns|probability|hit_count)/
        Atb.modifiers[$1.to_sym]
      else
        raise ActiveRecord::StatementInvalid, "Unenumerated attribute in #{self.name}"
      end
  end
end
