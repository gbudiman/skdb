class CreateVisitors < ActiveRecord::Migration
  def change
    create_table :visitors do |t|
      t.string             :address, null: false, index: true
      t.integer            :todays_count, default: 0
      t.date               :todays_date, null: false, index: true
      
      t.index              [:todays_date, :address], unique: true, name: 'todays_visitors'
      t.index              [:address, :todays_date], unique: true, name: 'visitors_timelime'
    end
  end
end
