class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string       :short, null: false
      t.string       :mid, null: false
      t.string       :long, null: false

      t.index        :short, unique: true
      t.index        :mid, unique: true
      t.index        :long, unique: true
    end
  end
end
