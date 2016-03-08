class Coupon < ActiveRecord::Base
  def self.rebuild_database!
    Utility.shut_up do
      ActiveRecord::Base.transaction do
        Coupon.delete_all

        File.open(Rails.root.join('db', 'coupons.csv')) do |f|
          f.each_line do |l|
            next if l[0] == '#'

            cells = l.gsub(/\n/, '').split(/\,/)
            input_code, reward, is_expired, instruction, credits = cells


            Coupon.create! input_code: input_code,
                           reward: reward,
                           is_expired: is_expired,
                           instruction: instruction,
                           credits: credits
          end
        end
      end
    end

    puts "#{Coupon.count} coupons exist"
  end
end
