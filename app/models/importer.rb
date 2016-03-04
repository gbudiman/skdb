class Importer
  attr_reader :result_skills, :result_stats

  def initialize _data, **_opts
    @skills = _data.skills if _data
    @stats = _data.stats if _data

    @opts = _opts # allow_hero_name_overwrite
                  # allow_skill_name_overwrite
    @result_skills = get_skills_statistics if _data
    @result_stats = get_stats_statistics if _data

    return self
  end

  def commit!
    ActiveRecord::Base.transaction do
      @result_skills[:attributes].keys.each do |atb|
        Atb.find_or_create_by!(name: atb)
      end

      @result_skills[:heros].each do |hero_key, hero_val|
        hero = Hero.find_or_initialize_by(static_name: hero_key)
        hero.name = hero_val
        hero.save!

        @result_skills[:skill_attributes].select{|skill_key, skill_val| skill_key.match(/\A#{hero_key}/)}.each do |sk, sv|
          skill = Skill.find_or_initialize_by(static_name: sk)
          skill.hero_id = hero.id
          skill.name = @result_skills[:skills][sk]
          skill.cooldown = @result_skills[:cooldown][sk] || 0
          skill.save!

          # ensure to clean-up existing SkillAttributes
          SkillAtb.where(skill_id: skill.id).destroy_all

          sv.each do |atb_key, atb_val|
            atb = Atb.find_by(name: atb_key)
            raise IndexError, "Fatal error: Attribute not found #{atb_key}" if atb == nil

            sa = SkillAtb.find_or_initialize_by(atb_id: atb.id,
                                                skill_id: skill.id)
            sa.value = atb_val[:value]
            sa.target = atb_val[:target]
            sa.save!
          end
        end 
      end

      puts "#{@result_skills[:attributes].keys.count} attributes updated"
      puts "#{@result_skills[:heros].keys.count} heroes updated"

      @stats.each do |row|
        hero = Hero.find_by static_name: row[:static_data]
        raise IndexError, "Fatal error: Hero #{row[:static_data]} not found" if hero == nil

        row[:datapoints].each do |datapoint_key, datapoint_data|
          datapoint_data.each do |_name, value|
            next if value == nil

            if _name == :atk
              name = row[:type] == :phy ? :atk : :mag
            else
              name = _name
            end

            Stat.save_or_update name: Stat.names[name], 
                                datapoint: Stat.datapoints[datapoint_key], 
                                hero_id: hero.id, 
                                value: value
          end
        end

        next unless row[:spd]
        Stat.save_or_update name: :spd, datapoint: :thirty, hero_id: hero.id, value: row[:spd]
      end

      #puts "#{@result_stats[:row_count]} heroes in stats sheet"
      puts "#{@result_stats[:hero_partial]} hero stats partially completed"
      puts "#{@result_stats[:hero_completed]} heroes have complete stats"
    end

    puts "Commit completed"
  end

  def test_attach_stub_skills _r
    @skills = _r
    @result_skills = get_skills_statistics
  end

  def test_attach_stub_stats _r
    @stats = _r
    @result_stats = get_stats_statistics
  end

  def self.test_stub_skills _r
    i = Importer.new nil
    i.test_attach_stub_skills _r
    i.test_attach_stub_stats []

    return i
  end

private
  def get_stats_statistics
    stat = {
      row_count: 0,
      hero_partial: 0,
      hero_completed: 0,
      expected_row_change: 0
    }

    @stats.each do |row|
      stat[:row_count] += 1
      next unless row[:type] # immediately skip if :type has not been populated

      stat[:hero_partial] += 1
      stat[:expected_row_change] += 1
      next unless row[:datapoints][:forty_5][:hp]

      stat[:hero_partial] -= 1
      stat[:hero_completed] += 1
    end

    return stat
  end

  def get_skills_statistics
    stat = {
      row_count: 0,
      heros: {},
      inverse_heros: {},
      skills: {},
      cooldown: {},
      rankless_skills: {},
      inverse_skills: {},
      attributes: {},
      skill_attributes: {},
      skill_attribute_count: 0
    }

    @skills.each do |row|
      stat[:row_count] += 1

      stat[:cooldown][row[:static_data]] = row[:cooldown]

      static_hero_name = Utility::strip_static_name_to_hero(row[:static_data])
      case stat[:heros][static_hero_name]
      when nil
        stat[:heros][static_hero_name] = row[:hero_name]
      when row[:hero_name]
      else
        unless @opts[:allow_hero_name_overwrite]
          raise NameError, "Hero name conflict occurred\n" +                   \
                           "Existing: #{stat[:heros][static_hero_name]}\n" +    \
                           "New     : #{row[:hero_name]}"
        end
      end

      case stat[:inverse_heros][row[:hero_name]]
      when nil
        stat[:inverse_heros][row[:hero_name]] = static_hero_name
      when static_hero_name
      else
        raise IndexError, "Hero static name conflict occurred for #{row[:hero_name]}\n" + \
                          "Existing: #{stat[:inverse_heros][row[:hero_name]]}\n" + \
                          "New     : #{static_hero_name}"
      end

      case stat[:skills][row[:static_data]]
      when nil
        stat[:skills][row[:static_data]] = row[:skill_name]
      when row[:skill_name]
      else
        unless @opts[:allow_skill_name_overwrite]
          raise NameError, "Skill name conflict accurred\n" +                  \
                           "Existing: #{stat[:skills][row[:static_data]]}\n" + \
                           "New     : #{row[:static_data]}"
        end
      end

      static_skill_name_without_hero_rank = Utility::mask_hero_rank_in_static_name(row[:static_data])
      case stat[:inverse_skills][row[:skill_name]]
      when nil
        stat[:inverse_skills][row[:skill_name]] = static_skill_name_without_hero_rank
      when static_skill_name_without_hero_rank
      else
        raise IndexError, "Skill static name conflict occurred for #{row[:skill_name]}\n" + \
                          "Existing: #{stat[:inverse_skills][row[:skill_name]]}\n" + \
                          "New     : #{static_skill_name_without_hero_rank}"
      end

      case stat[:rankless_skills][static_skill_name_without_hero_rank]
      when nil
        stat[:rankless_skills][static_skill_name_without_hero_rank] = row[:skill_name]
      when row[:skill_name]
      else
        raise NameError, "Hero's Skill of the same category must have same name\n" + \
                         "Existing: #{stat[:rankless_skills][static_skill_name_without_hero_rank]}\n" + \
                         "New     : #{row[:skill_name]}"
      end

      row[:attributes].each do |atb|
        stat[:skill_attribute_count] += 1
        stat[:attributes][atb[:name]] = true

        stat[:skill_attributes][row[:static_data]] ||= Hash.new
        scope = stat[:skill_attributes][row[:static_data]]
        case scope[atb[:name]]
        when nil
          scope[atb[:name]] = { target: atb[:target], value: atb[:value] }
        else
          raise IndexError, "Skill #{row[:static_data]} already has attribute #{atb[:name]}"
        end
      end
    end

    return stat
  end
end
