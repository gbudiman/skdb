class CreateSkillAttributes < ActiveRecord::Migration
  def change
    create_table :skill_atbs do |t|
      t.string                 :value, null: false
      t.integer                :target, null: false
      t.belongs_to             :skill, null: false, index: true
      t.belongs_to             :atb, null: false, index: true

      t.timestamps             null: false

      t.index                  [:skill_id, :atb_id], unique: true, name: 'unique_skill_attribute'
    end
  end
end
