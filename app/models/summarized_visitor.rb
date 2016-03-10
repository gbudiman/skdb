class SummarizedVisitor < ActiveRecord::Base
	def self.report
		h = Hash.new

		SummarizedVisitor.all.order(todays_date: :desc).each do |r|
			h[r.todays_date] = { visit_count: r.visit_count,
													 unique_count: r.unique_count }
		end

		return h
	end
end
