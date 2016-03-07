class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string       :input_code, null: false
      t.string       :reward, null: false
      t.boolean      :is_expired, default: false
      t.text         :instruction, null: false
      t.text         :credits, null: false

      t.index        [:input_code, :reward], unique: true
    end
  end
end
