class Atb < ActiveRecord::Base
  enum category: [ :direct_attack,
                   :mechanics,
                   :healing,
                   :immunities,
                   :debuffs,
                   :revivals,
                   :stat_modifiers]
  enum modifier: [ :fraction, :amount, :turns, :probability, :hit_count,
                   :continuous_physical_damage_fraction,
                   :continuous_magical_damage_fraction,
                   :aftershock_physical_damage_fraction,
                   :aftershock_magical_damage_fraction,
                   :add_damage_fraction_of_target_max_hp ]

  before_validation :parse

  validates :name, :modifier, :effect, presence: true, strict: ActiveRecord::StatementInvalid

  has_many :skill_atbs, dependent: :destroy
  has_many :skills, through: :skill_atbs

  def self.search _q
    result = Array.new
    
    Atb.where('atbs.name LIKE :q', q: "%#{_q}%")
       .joins(skills: :hero)
       .select('atbs.id            AS atb_id,
                atbs.effect        AS atb_effect,
                skill_atbs.target  AS skill_target,
                COUNT(DISTINCT heros.id) AS count')
       .group('atbs.effect, skill_atbs.target')
       .each do |r| 
      result.push({
        effect:        r.atb_effect,
        target:        SkillAtb.targets.keys[r.skill_target],
        count:         r.count,
      })
    end

    return result
  end

  def parse
    modifier_regexes = Atb.modifiers.keys.join('|')
    case self.name
    when /(#{modifier_regexes})/ 
      modifier = $1

      sanitize = case self.name \
      when /\_of\_/
        "_#{modifier}_of"
      else
        "_#{modifier}"
      end

      self.modifier = Atb.modifiers[modifier.to_sym]
      self.effect = self.name.gsub(/#{sanitize}/i, '')
    else
      raise ActiveRecord::StatementInvalid, "Unenumerated attribute in #{self.name}"
    end
  end
end
