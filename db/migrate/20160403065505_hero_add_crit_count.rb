class HeroAddCritCount < ActiveRecord::Migration
  def change
    add_column      :heros, :crit_count, :integer, null: false, default: -1
  end
end
