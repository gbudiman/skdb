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

  def self.details _id
    result = {
      hero_id: nil,
      hero_name: nil,
      skill_id: nil,
      static_name: nil,
      skill_name: nil,
      skill_category: nil,
      skill_cooldown: nil,
      attributes: Hash.new
    }
    Hero.joins('INNER JOIN skills AS sk
                   ON        heros.id = sk.hero_id
                INNER JOIN skill_atbs AS sa
                   ON           sk.id = sa.skill_id
                INNER JOIN atbs
                   ON         atbs.id = sa.atb_id')
        .where(id: _id)
        .select('heros.id AS id,
                 heros.name AS hero_name,
                 heros.rank AS hero_rank,
                 sk.id AS skill_id,
                 sk.static_name AS static_name,
                 sk.name AS skill_name,
                 sk.category AS skill_category,
                 sk.cooldown AS skill_cooldown,
                 sa.value AS atb_value,
                 sa.target AS atb_target,
                 atbs.id AS atb_id,
                 atbs.name AS atb_name,
                 atbs.category AS atb_category,
                 atbs.modifier AS atb_modifier').each do |r|
      result[:hero_id] = r.id
      result[:skill_id] = r.skill_id
      result[:static_name] = r.static_name

      result[:hero_name] = r.hero_name
      result[:hero_rank] = r.hero_rank.to_i
      result[:skill_name] = r.skill_name
      result[:skill_category] = Skill.categories.keys[r.skill_category]
      result[:skill_cooldown] = r.skill_cooldown

      result[:attributes][r[:atb_id]] = {
        atb_name: r.atb_name,
        atb_category: r.atb_category,
        atb_modifier: Atb.modifiers.keys[r.atb_modifier],
        atb_value: r.atb_value,
        atb_target: SkillAtb.targets.keys[r.atb_target]
      }
    end
    
    return result
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
