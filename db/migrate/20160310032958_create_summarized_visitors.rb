class CreateSummarizedVisitors < ActiveRecord::Migration
  def change
    create_table :summarized_visitors do |t|
    	t.date           :todays_date, null: false
    	t.integer        :visit_count, null: false
    	t.integer        :unique_count, null: false

      t.timestamps     null: false

      t.index          :todays_date, unique: true
    end
  end
end
