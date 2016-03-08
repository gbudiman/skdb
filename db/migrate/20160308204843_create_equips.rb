class CreateEquips < ActiveRecord::Migration
  def change
    create_table :equips do |t|
      t.integer           :rank, null: false
      t.string            :name
      t.integer           :slot

      t.index             :name, unique: true
      t.timestamps        null: false
    end
  end
end
