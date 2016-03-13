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
                   :before_dying_turns,
                   :before_dying_invincible_turns,
                   :before_dying_critical_rate_increase_fraction,
                   :before_dying_counter_rate_increase_fraction,
                   :proportional_increase_fraction,
                   :proportional_limit_fraction,
                   :continuous_physical_damage_fraction,
                   :continuous_magical_damage_fraction,
                   :aftershock_physical_damage_fraction,
                   :aftershock_magical_damage_fraction,
                   :add_damage_target_max_hp_fraction,
                   :with_ignore_defense_probability,
                   :with_lethal_attack_probability,
                   :with_critical_hit_probability,
                   :with_piercing_probability,
                   :on_counter_attack_amount,
                   :on_counter_attack_probability,
                   :on_counter_attack_turns,
                   :on_regular_attack_probability,
                   :on_regular_attack_amount,
                   :on_regular_attack_turns,
                   :on_speed_attack_amount,
                   :on_speed_attack_probability,
                   :on_speed_attack_turns,
                   :extra_damage_fraction,
                   :extra_damage_probability,
                   :fraction_of_defense,
                   :on_hp_below_threshold_fraction,
                   :on_hp_below_threshold,
                   :hp_fraction,
                   :from_5_target_aoe_fraction,
                   :stat_original_fraction,
                   :fraction, :amount, :turns, :probability, :hit_count, ]

  before_validation :parse

  validates :name, :modifier, :effect, presence: true, strict: ActiveRecord::StatementInvalid

  has_many :skill_atbs, dependent: :destroy
  has_many :skills, through: :skill_atbs

  def self.get_stat_modifiers
    effects = Hash.new
    results = Hash.new
    denorms = Array.new
    e = Atb.where(category: Atb.categories[:stat_modifiers]).pluck(:effect)
    Hero.fetch_having_atb_effect(effect: e, for_stat_modifiers: true).each do |k, d|
      no_stat = k.split(/\_/)[1..-1]
      c_increase = no_stat.delete('increase')
      c_decrease = no_stat.delete('decrease')
      cid = (c_increase || c_decrease).to_sym

      stat_mdf_name = no_stat.join('_').humanize

      results[stat_mdf_name] ||= { increase: Array.new, decrease: Array.new }
      results[stat_mdf_name][cid] += d
    end

    results.each do |k, d|
      denorms.push({
        modifier: k,
        increase: d[:increase],
        decrease: d[:decrease]
      })
    end

    return denorms
  end

  def self.get_status_effects
    inflicts = Hash.new
    immunities = Hash.new
    cross_table = { inflicts: Hash.new, immunities: Hash.new, recomb: Hash.new }
    denorms = Array.new

    Atb.where(category: Atb.categories[:debuffs]).each do |r|
      effect = r.effect.split(/\_/).last
      inflicts[effect] = r.effect
    end

    Atb.where(category: Atb.categories[:immunities]).each do |r|
      effect = r.effect.split(/\_/)[2]

      if inflicts[effect]
        immunities[effect] = r.effect
      elsif r.effect =~ /all_debuff/
        all_debuff = r.effect.split(/\_/)[2..-1].join('_') 
        immunities[all_debuff] = r.effect
      end
    end

    cross_table[:inflicts] = Hero.fetch_having_atb_effect(effect: inflicts.values, simplified: true)
    cross_table[:immunities] = Hero.fetch_having_atb_effect(effect: immunities.values, simplified: true)

    cross_table[:inflicts].each do |k, v|
      val = inflicts.key(k)
      cross_table[:recomb][val] ||= Hash.new
      cross_table[:recomb][val][:inflict] ||= Array.new
      cross_table[:recomb][val][:inflict] += v
    end

    cross_table[:immunities].each do |k, v|
      next if k =~ /all_debuff/

      val = immunities.key(k)
      cross_table[:recomb][val] ||= Hash.new
      cross_table[:recomb][val][:immunity] ||= Array.new
      cross_table[:recomb][val][:immunity] += v
    end

    cross_table[:immunities].select{|k, v| k =~ /all_debuff/}.each do |k, v|
      cross_table[:recomb].each do |recomb, d|
        d[:immunity] ||= Array.new
        d[:immunity] += v
      end
    end

    cross_table[:recomb].each do |k, v|
      h = Hash.new
      h[:status_effect] = k
      h[:inflicts] = v[:inflict]
      h[:immunities] = v[:immunity]
      denorms.push h
    end

    return denorms
  end

  def self.search _q
    result = Array.new
    
    Atb.where("atbs.name #{Utility.query_like} :q", q: "%#{_q}%")
       .joins(skills: :hero)
       .select('atbs.effect        AS atb_effect,
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

  def self.find_heros_having _x
    Atb.where(_x).joins(skill_atbs: [skill: :hero])
       .pluck('heros.name', 'skills.name', 'atbs.name')
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
