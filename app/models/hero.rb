class Hero < ActiveRecord::Base
  before_validation :parse

  validates :name, :static_name, :rank, presence: true, strict: ActiveRecord::StatementInvalid
  validates :static_name, format: { with: /\A[A-Za-z\_]+\_\d\z/ }, strict: ActiveRecord::StatementInvalid
  validates :rank, numericality: { only_integer: true,
                                   greater_than: 0,
                                   less_than_or_equal_to: 6 }, strict: ActiveRecord::StatementInvalid

  validate :static_name_only_has_one_numeric!
  validate :static_name_matches_rank_correctly!

  has_many :skills, dependent: :destroy

  def self.fetch_having_atb_effect _h
    hero_superset = Atb.joins(skills: :hero)
                       .where('atbs.effect = :e', e: _h[:effect])
                       .where('skill_atbs.target = :r', r: SkillAtb.targets[_h[:target]])
                       .pluck('heros.id').uniq
    Hero.details(hero_superset)
  end

  def self.search _q
    result = Array.new

    Hero.where('name LIKE :q', q: "%#{_q}%").each do |h|
      result.push({
        id: h.id,
        name: h.name,
        rank: h.rank
      })
    end

    return result
  end

  def self.details _ids
    result = Hash.new

    Hero.joins('INNER JOIN skills AS sk
                   ON        heros.id = sk.hero_id
                INNER JOIN skill_atbs AS sa
                   ON           sk.id = sa.skill_id
                INNER JOIN atbs
                   ON         atbs.id = sa.atb_id')
        .where('heros.id IN(:id)', id: _ids)
        .select('heros.id           AS hero_id,
                 heros.static_name  AS hero_static_name,
                 heros.name         AS hero_name,
                 heros.rank         AS hero_rank,
                 sk.id              AS skill_id,
                 sk.static_name     AS static_name,
                 sk.name            AS skill_name,
                 sk.category        AS skill_category,
                 sk.cooldown        AS skill_cooldown,
                 sa.value           AS atb_value,
                 sa.target          AS atb_target,
                 atbs.id            AS atb_id,
                 atbs.name          AS atb_name,
                 atbs.category      AS atb_category,
                 atbs.effect        AS atb_effect,
                 atbs.modifier      AS atb_modifier').each do |r|
      result[r.hero_id] ||= Hash.new

      hero                = result[r.hero_id]
      hero[:hero_id]      = r.hero_id
      hero[:hero_name]    = r.hero_name
      hero[:hero_rank]    = r.hero_rank.to_i
      hero[:url_friendly] = r.hero_static_name.split(/\_/).first
      hero[:skills]     ||= Hash.new

      # Skill sub-member ######
      category = Skill.categories.keys[r.skill_category]
      hero[:skills][category] ||= Hash.new
      skill = hero[:skills][category]

      skill[:id]            = r.skill_id
      skill[:name]          = r.skill_name
      skill[:category]      = Skill.categories.keys[r.skill_category]
      skill[:cooldown]      = r.skill_cooldown
      skill[:attributes]  ||= Hash.new

        # Attribute sub-member ##
        skill[:attributes][r.atb_effect] ||= Hash.new
        atb = skill[:attributes][r.atb_effect]

        atb[:id]            = r.atb_id
        atb[:name]          = r.atb_name
        atb[:category]      = r.atb_category
        atb[:effect]        = r.atb_effect
        atb[:target]        = SkillAtb.targets.keys[r.atb_target]
        atb[:modifiers]   ||= Hash.new

          # Attribute modifier ####
          modifier = Atb.modifiers.keys[r.atb_modifier]
          atb[:modifiers][modifier] = r.atb_value
          # End Attribute modifier #
        # End Attribute #########
      # End Skill #############
    end
    
    return result.values
  end

  def parse
    self.static_name =~ /\_(\d)\z/
    self.rank = $1
  end

private
  def static_name_only_has_one_numeric!
    unless self.static_name =~ /\A[A-Za-z\_]+\_\d\z/
      raise ActiveRecord::StatementInvalid, "Hero static name can only have one numeric: #{self.static_name}"
    end
  end

  def static_name_matches_rank_correctly!
    self.static_name =~ /\_(\d)\z/
    inferred_rank = $1.to_i

    if self.rank != inferred_rank
      raise ActiveRecord::StatementInvalid,                                    \
            "Static name: #{self.static_name}\n" +                             \
            "Rank: #{self.rank}\n" +                                           \
            "Inferred rank from static name must match hero's rank"
    end
  end
end
