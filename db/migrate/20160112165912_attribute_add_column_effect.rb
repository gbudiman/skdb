class AttributeAddColumnEffect < ActiveRecord::Migration
  def change
    add_column :atbs, :effect, :string, null: false
    add_index :atbs, :effect
  end
end
