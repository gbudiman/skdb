class CreateAttributes < ActiveRecord::Migration
  def change
    create_table :atbs do |t|
      t.string                 :name, null: false
      t.integer                :category, null: true
      t.integer                :modifier, null: false

      t.timestamps             null: false

      t.index                  [:name, :modifier], unique: true, name: 'unique_attribute_name_modifier'
    end
  end
end
