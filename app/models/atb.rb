class Atb < ActiveRecord::Base
  enum category: [ :direct_attack,
                   :mechanics,
                   :healing,
                   :immunities,
                   :debuffs,
                   :revivals,
                   :stat_modifiers]
  enum modifier: [ :as_invincible_magical_damage_increase_fraction,
                   :as_invincible_physical_damage_increase_fraction,
                   :as_invincible_turns,
                   :proportional_increase_fraction,
                   :proportional_limit_fraction,
                   :continuous_physical_damage_fraction,
                   :continuous_magical_damage_fraction,
                   :aftershock_physical_damage_fraction,
                   :aftershock_magical_damage_fraction,
                   :add_damage_target_max_hp_fraction,
                   :with_ignore_defense_probability,
                   :on_counter_attack_amount,
                   :on_regular_attack_amount,
                   :on_regular_attack_turns,
                   :on_speed_attack_amount,
                   :extra_damage_fraction,
                   :extra_damage_probability,
                   :ally_hp_fraction,
                   :fraction, :amount, :turns, :probability, :hit_count, ]

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

  def self.dump_effects
    Atb.all.pluck(:effect).uniq.each do |e|
      puts "  #{e}: ,"
    end
  end

  def parse
    Atb.modifiers.keys.each do |regex_key|
      if self.name =~ /#{regex_key}/
        self.modifier = Atb.modifiers[regex_key.to_sym]
        self.effect = self.name.gsub(/\_?#{modifier}/i, '')

        return self
      end
    end

    raise ActiveRecord::StatementInvalid, "Unenumerated attribute in #{self.name}"
  end
end
