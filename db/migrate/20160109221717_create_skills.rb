class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.string                 :static_name, null: false
      t.string                 :name, null: false
      t.integer                :category, null: false
      t.integer                :cooldown, null: false, default: 0
      t.belongs_to             :hero, null: false

      t.timestamps             null: false

      t.index                  [:hero_id, :static_name], unique: true, name: 'hero_unique_skill_static_name'
      t.index                  [:hero_id, :name], unique: true, name: 'hero_unique_skill_name'
    end
  end
end
