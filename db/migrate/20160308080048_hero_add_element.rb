class HeroAddElement < ActiveRecord::Migration
  def change
    add_column       :heros, :element, :integer, null: true
    add_column       :heros, :category, :string, null: true
  end
end
