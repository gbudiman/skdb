class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.belongs_to        :hero, index: true
      t.integer           :name, null: false
      t.integer           :datapoint, null: false
      t.integer           :value, null: false            

      t.timestamps        null: false

      t.index             [:hero_id, :name, :datapoint], unique: true, name: 'unique_hero_stat'
    end
  end
end
