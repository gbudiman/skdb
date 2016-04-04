class SkillAddHitCount < ActiveRecord::Migration
  def change
    add_column    :skills, :hit_count, :integer, null: false, default: -1
  end
end
