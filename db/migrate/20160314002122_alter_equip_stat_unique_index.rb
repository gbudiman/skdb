class AlterEquipStatUniqueIndex < ActiveRecord::Migration
  def change
    remove_index    :equip_stats, name: 'index_equip_stats_on_equip_id_and_category_and_attribute'
    add_index       :equip_stats, [:equip_id, :category, :atb, :value], unique: true
  end
end
