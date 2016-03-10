namespace :visitors do
	desc "Summarize visitors up to last week and destroy original records"
	task summarize: :environment do
		Visitor.summarize_and_destroy_records!
	end
end
