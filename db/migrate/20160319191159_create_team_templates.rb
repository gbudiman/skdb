class CreateTeamTemplates < ActiveRecord::Migration
  def change
    create_table :team_templates do |t|
      t.string        :name, null: false
      t.text          :description, null: true

      t.timestamps    null: false
    end
  end
end
