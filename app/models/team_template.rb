class TeamTemplate < ActiveRecord::Base
  has_many :hero_teams, dependent: :destroy

  def add_hero! **_h
    # Example: team_template.add_hero name: 'karin_6'
    hero = Hero.find_by static_name: _h[:name]
    raise ActiveRecord::RecordNotFound, "Hero #{_h[:name]} not found" if hero == nil

    ht = HeroTeam.find_or_initialize_by hero_id: hero.id, team_template_id: self.id
    ht.save!
  end

  def self.rebuild **_h
    # Example: TeamTemplate.build name: 'test_team_1', description: 'just test', heros: ['karin_6', leo_6']

    raise ArgumentError, 'Template name must be supplied' if _h[:name] == nil
    raise ArgumentError, 'Please supply at least 1 hero in a team' if _h[:heros] == nil or _h[:heros].length == 0
    raise ArgumentError, 'At most only 5 heros can be included in a team' if _h[:heros].length > 5

    t = TeamTemplate.find_or_initialize_by name: _h[:name]
    t.description = _h[:description]
    t.save!

    ActiveRecord::Base.transaction do
      HeroTeam.where(team_template_id: t.id).destroy_all
      _h[:heros].each do |_name|
        t.add_hero! name: _name
      end
    end
  end

  def list_heros _method = :object
    ht = HeroTeam.where(team_template_id: self.id)
                 .joins('INNER JOIN heros
                           ON heros.id = hero_id')
                 .select('heros.*')
                 
    case _method
    when :object
      return ht
    else
      return ht.pluck(_method)
    end
  end

  def self.rebuild_database!
    ActiveRecord::Base.transaction do
      Utility.shut_up do
        TeamTemplate.destroy_all

        import!
      end
    end

    puts "#{TeamTemplate.count} team templates recorded"
    return TeamTemplate.count
  end

  def self.fetch
    result = Hash.new

    TeamTemplate.joins('LEFT OUTER JOIN hero_teams AS ht
                          ON ht.team_template_id = team_templates.id
                        LEFT OUTER JOIN heros AS h
                          ON ht.hero_id = h.id')
                .select('ht.hero_id AS hero_id,
                         h.name AS hero_name,
                         team_templates.name AS team_name,
                         team_templates.description AS team_description,
                         team_templates.id AS team_id')
                .each do |r|
      
      result[r.team_id] ||= { name: r.team_name, 
                              description: r.team_description, 
                              hero_ids: Array.new,
                              hero_names: Array.new }

      result[r.team_id][:hero_names].push(r.hero_name.split.last)
      result[r.team_id][:hero_ids].push(r.hero_id)
    end

    return result
  end

private
  def self.import!
    RemoteTable.new('https://raw.githubusercontent.com/gbudiman/skdb/master/db/team_templates.csv').each do |r|
      heros = Array.new

      (0..4).each do |i|
        cat = r["h#{i}"]
        if cat.strip.length > 0
          heros.push cat
        end
      end

      TeamTemplate.rebuild name: r['name'],
                           heros: heros,
                           description: r['description']
    end
  end
end
