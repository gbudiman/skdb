class CreateHeros < ActiveRecord::Migration
  def change
    create_table :heros do |t|
      t.string                 :static_name, null: false
      t.string                 :name, null: false
      t.integer                :rank, null: false

      t.timestamps             null: false

      t.index                  [:static_name], unique: true, name: 'hero_unique_static_name'
      t.index                  [:name], unique: true, name: 'hero_unique_name'
      t.index                  [:static_name, :name, :rank], unique: true, name: 'hero_unique_name_rank'
    end
  end
end
