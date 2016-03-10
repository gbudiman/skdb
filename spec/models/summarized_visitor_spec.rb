require 'rails_helper'

RSpec.describe SummarizedVisitor, type: :model do
  it 'should run correctly' do
  	today = Date.today
  	Visitor.create todays_date: (today -10), address: '1.2.3.4', todays_count: 12
  	Visitor.create todays_date: (today -10), address: '1.2.3.5', todays_count: 11
  	Visitor.create todays_date: (today -10), address: '1.2.3.6', todays_count: 10
  	Visitor.create todays_date: (today -10), address: '1.2.3.7', todays_count: 9

  	Visitor.create todays_date: (today -22), address: '1.2.3.4', todays_count: 12

  	Visitor.summarize_and_destroy_records!

  	sv_1 = SummarizedVisitor.find_by todays_date: (today -10)
  	sv_2 = SummarizedVisitor.find_by todays_date: (today -22)

  	expect(sv_1.visit_count).to eq(12+11+10+9)
  	expect(sv_1.unique_count).to eq 4

  	expect(sv_2.visit_count).to eq 12
  	expect(sv_2.unique_count).to eq 1
  end
end
