class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.integer          :slot, null: false
      t.string           :value, null: false
      t.belongs_to       :hero, null: false

      t.index            [:hero_id, :slot], unique: true
      t.timestamps       null: false
    end
  end
end
