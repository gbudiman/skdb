class HeroAddAcquisition < ActiveRecord::Migration
  def change
  	add_column     :heros, :acquisition, :string, null: true
  end
end
