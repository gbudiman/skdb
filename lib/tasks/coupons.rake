namespace :coupons do
  desc "Rebuild coupons database"
  task rebuild: :environment do
  	Coupon.rebuild_database!
  end

end
