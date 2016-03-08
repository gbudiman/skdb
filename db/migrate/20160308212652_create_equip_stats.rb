class CreateEquipStats < ActiveRecord::Migration
  def change
    create_table :equip_stats do |t|
      t.belongs_to            :equip, null: false
      t.integer               :category, null: false
      t.string                :attribute, null: false
      t.integer               :value, null: false
      t.integer               :variance, default: 0

      t.index                 [:equip_id, :category, :attribute], unique: true
      t.timestamps            null: false
    end
  end
end
