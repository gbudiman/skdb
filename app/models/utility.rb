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
    can_be_silenced = false
    previous_level = nil

    begin
      previous_level = Rails.logger.level
      Rails.logger.level = 1
      can_be_silenced = true
    rescue Exception => e
    end

    if can_be_silenced
      t = Rails.logger.level
      Rails.logger.level = 1
      puts "Temporarily setting Rails.logger.level to 1"

      yield

      puts "Rails.logger.level set back to #{previous_level}"
      Rails.logger.level = previous_level
    else
      yield
    end
  
  end

  def self.query_like
    case ActiveRecord::Base.connection.adapter_name.downcase.to_sym
    when :postgresql, :pg, :psql, :pgsql
      return 'ILIKE'
    end

    return 'LIKE'
  end

private
  def self.ensure_proper_static_name! _x
    raise NameError unless _x =~ /\A([A-Za-z\_]+)\_(\d)\_(\d)\z/

    return { hero: $1, rank: $2, skill: $3 }
  end
end
