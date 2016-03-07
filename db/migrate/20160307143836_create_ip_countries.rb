class CreateIpCountries < ActiveRecord::Migration
  def change
    create_table :ip_countries do |t|
      t.integer      :address_start, null: false, limit: 8
      t.integer      :address_end, null: false, limit: 8
      t.belongs_to   :country, null: false, index: true

      t.index        :address_start, unique: true
      t.index        :address_end, unique: true
    end
  end
end
