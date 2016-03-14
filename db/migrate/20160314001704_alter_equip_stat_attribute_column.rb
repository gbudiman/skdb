class AlterEquipStatAttributeColumn < ActiveRecord::Migration
  def change
    remove_column     :equip_stats, :attribute
    add_column        :equip_stats, :atb, :string, null: false
  end
end
