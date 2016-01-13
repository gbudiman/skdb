class Skill < ActiveRecord::Base
  enum category: [ :active_0, :active_1, :passive, :awakening ]

  before_validation :parse

  validates :name, :static_name, :category, :cooldown, presence: true, strict: ActiveRecord::StatementInvalid
  validates :cooldown, numericality: { integer_only: true, 
                                       greater_than_or_equal_to: 0 }, strict: ActiveRecord::StatementInvalid

  validate :static_name_has_two_numericals!
  validate :static_name_matches_category_correctly!
  validate :active_skill_has_non_zero_cooldown!

  belongs_to :hero
  validates :hero, presence: true, strict: ActiveRecord::StatementInvalid
  
  has_many :skill_atbs, dependent: :destroy

  def self.search _q
    result = Array.new

    Skill.joins(:hero)
         .where('skills.name LIKE :q', q: "%#{_q}%")
         .select('skills.id AS skill_id,
                  skills.name AS skill_name,
                  skills.cooldown AS skill_cooldown,
                  skills.category AS skill_category,
                  heros.id AS hero_id,
                  heros.name AS hero_name,
                  heros.rank AS hero_rank').each do |h|
      result.push({
        hero_id: h.hero_id,
        hero_name: h.hero_name,
        hero_rank: h.hero_rank,
        skill_id: h.skill_id,
        skill_name: h.skill_name,
        skill_cooldown: h.skill_cooldown,
        skill_category: Skill.categories.keys[h.skill_category]
      })
    end

    return result
  end

  def parse
    self.static_name =~ /\_(\d)\z/
    self.category = $1.to_i
  end

private
  def active_skill_has_non_zero_cooldown!
    case Skill.categories[self.category]
    when Skill.categories[:passive]
    else
      if self.cooldown == 0
        raise ActiveRecord::StatementInvalid,                                  \
              "#{self.category} skill #{self.static_name} must have non-zero cooldown"
      end
    end
  end

  def static_name_has_two_numericals!
    self.static_name =~ /\A[A-Za-z\_]+\_(\d)\_(\d)\z/
    if $1 == nil or $2 == nil or $1.to_i == nil or $2.to_i == nil
      raise ActiveRecord::StatementInvalid,                                    \
            "Skill's static name #{self.static_name} does not have exactly 2 numericals"
    end
  end

  def static_name_matches_category_correctly!
    self.static_name =~ /\_(\d)\z/
    inferred_skill_category_enumeration = $1.to_i

    if inferred_skill_category_enumeration != Skill.categories[self.category.to_sym]
      raise ActiveRecord::StatementInvalid,                                    \
            "Skill static name: #{self.static_name}\n" +                       \
            "Skill category: #{self.category} (enum: #{Skill.categories[self.category]})\n" +   \
            "Inferred category from static name must match skill's category"
    end
  end
end
