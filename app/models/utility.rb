class Utility
  def self.strip_static_name_to_hero _x
    r = self.ensure_proper_static_name! _x

    return r[:hero] + '_' + r[:rank]
  end

  def self.mask_hero_rank_in_static_name _x
    r = self.ensure_proper_static_name! _x

    return r[:hero] + '_x_' + r[:skill]
  end

  def self.shut_up
    t = Rails.logger.level
    Rails.logger.level = 1
    puts "Temporarily setting Rails.logger.level to 1"

    yield
    
    Rails.logger.level = t
    puts "Rails.logger.level set back to #{t}"
  end

private
  def self.ensure_proper_static_name! _x
    raise NameError unless _x =~ /\A([A-Za-z\_]+)\_(\d)\_(\d)\z/

    return { hero: $1, rank: $2, skill: $3 }
  end
end
