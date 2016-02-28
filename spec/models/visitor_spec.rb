require 'rails_helper'

RSpec.describe Visitor, type: :model do
  before :each do
    @v = Visitor.new address: '8.0.8.0', todays_date: Date.today
  end

  context 'basic validation' do
    after :each do 
      expect { @v.log }.to raise_error(ActiveRecord::StatementInvalid)
    end

    it 'should invalidate empty address' do
      @v.address = nil
    end
  end

  it 'should save correctly' do
    Visitor.where(address: @v.address).destroy_all
    expect { @v.log }.to change { Visitor.count }.by 1
    expect(Visitor.find_by(address: @v.address, todays_date: @v.todays_date).todays_count).to eq(1)
  end

  context 'duplication test' do
    before :each do
      @v.log
    end

    it 'should increment todays_count by 1 on identical todays_date' do
      previous_count = Visitor.find(@v.id).todays_count
      w = @v.dup
      w.log
      expect(Visitor.find(@v.id).todays_count).to eq(previous_count + 1)
    end

    it 'should create new row on different todays_date' do
      previous_count = Visitor.find(@v.id).todays_count
      w = @v.dup
      w.todays_date = Date.today + 1
      expect { w.log }.to change { Visitor.count }.by 1
      expect(Visitor.find(@v.id).todays_count).to eq(previous_count)
      expect(Visitor.find(w.id).todays_count).to eq(1)
    end
  end
end
