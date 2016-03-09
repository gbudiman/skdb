class EquipAddAcquisition < ActiveRecord::Migration
  def change
  	add_column      :equips, :acquisition, :string, null: true
  end
end
