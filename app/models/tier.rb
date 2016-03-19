class Tier < ActiveRecord::Base
  enum category: [:adventure, 
                  :cr_easy,
                  :cr_normal,
                  :raid,
                  :pvp,
                  :tower,
                  :boss,
                  :d_hard]

  belongs_to :hero
  validates :hero, presence: true

  def self.fetch
    result = Hash.new
    denorm = Array.new

    Hero.joins('LEFT OUTER JOIN tiers
                  ON    tiers.hero_id = heros.id')
        .where(rank: 6)
        .select('heros.id AS id,
                 heros.name AS hero_name,
                 heros.rank AS hero_rank,
                 heros.category AS hero_category,
                 heros.element AS hero_element,
                 tiers.category AS tier_category,
                 tiers.value AS tier_value').each do |r|
      result[r.id] ||= Hash.new
      result[r.id][:name] = r.hero_name
      result[r.id][:rank] = r.hero_rank
      result[r.id][:category] = r.hero_category
      result[r.id][:element] = Hero.elements.keys[r.hero_element]
      result[r.id][:tiers] ||= Hash[Tier.categories.map { |k, v| [k, nil] }]

      result[r.id][:tiers][Tier.categories.keys[r.tier_category]] = r.tier_value
    end

    result.each do |id, r|
      h = {
        adventure: nil,
        cr_easy: nil,
        cr_normal: nil,
        raid: nil,
        pvp: nil,
        tower: nil,
        boss: nil
      }
      h[:id] = id
      h[:name] = r[:name]
      h[:stripped_name] = r[:name].split(/\s+/).last
      h[:rank] = r[:rank]
      h[:category] = r[:category]
      h[:element] = r[:element]

      r[:tiers].each do |category, value|
        h[category] = value
      end

      denorm.push h
    end

    return denorm
  end
end
