class CreateHeroTeams < ActiveRecord::Migration
  def change
    create_table :hero_teams do |t|
      t.belongs_to      :team_template, null: false
      t.belongs_to      :hero, null: false

      t.timestamps      null: false

      t.index           [:team_template_id, :hero_id], unique: true, name: 'map_team_to_hero'
      t.index           [:hero_id, :team_template_id], unique: true, name: 'map_hero_to_team'
    end  
  end
end
