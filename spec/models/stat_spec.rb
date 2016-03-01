require 'rails_helper'

RSpec.describe Stat, type: :model do
  before :each do
    @h = Hero.create name: 'Super Star Hero', rank: 6, static_name: 'hero_6'
    @s = Stat.create hero_id: @h.id, 
                     name: :spd, 
                     datapoint: :thirty, 
                     value: 21
  end

  context 'basic validation' do
    context 'duplication' do
      before :each do
        @s.save_or_update
      end

      it 'should not create new row' do
        t = @s.dup
        expect { t.save_or_update }.not_to change { Stat.count }
        expect(t.id).to eq(@s.id)
      end

      it 'should update :value as needed' do
        t = @s.dup
        t.value = @s.value + 5

        expect { t.save_or_update }.not_to change { Stat.count }
        expect(t.id).to eq(@s.id)
        expect(Stat.find(t.id).value).to eq(@s.value + 5)
      end
    end

    context 'data integrity' do
      before :each do 
        @s.save_or_update
      end

      it 'should cascade deletion from Hero' do
        @h.destroy
        expect { Stat.find(hero_id: @h.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
