class CreateTiers < ActiveRecord::Migration
  def change
    create_table :tiers do |t|
      t.integer          :category, null: false
      t.string           :value, null: false
      t.belongs_to       :hero, null: false

      t.index            [:hero_id, :category], unique: true
      t.timestamps       null: false
    end
  end
end
