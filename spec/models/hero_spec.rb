require 'rails_helper'

RSpec.describe Hero, type: :model do
  before :each do
    @hero = Hero.new
    @hero.name = 'Test Hero'
    @hero.rank = 6
    @hero.static_name = 'test_hero_6'
  end

  context "nullity tests" do
    after :each do
      expect { @hero.save }.to raise_error(ActiveRecord::StatementInvalid)
    end

    it "should have valid name" do
      @hero.name = nil
    end

    # it "should have valid rank" do
    #   @hero.rank = nil
    # end

    it "should have valid static_name" do
      @hero.static_name = nil
    end
  end

  context "validation tests" do
    after :each do
      expect { @hero.save! }.to raise_error(ActiveRecord::StatementInvalid)
    end

    it "should have proper static_name" do
      @hero.static_name = 'test_hero'
    end

    it "should have exactly one numeric" do
      @hero.static_name = 'tests_hero_6_1'
    end

    # it "should have static_name matching rank" do
    #   @hero.rank = 5
    # end
  end

  context "duplication tests" do
    before :each do
      @hero.save!
      @hero_dup = @hero.dup
    end

    after :each do
      expect { @hero_dup.save! }.to raise_error(ActiveRecord::RecordNotUnique)
    end

    it "should invalidate duplicate insert with only different name" do
      @hero_dup.name = 'Test Hero Duplicate'
    end
  end
end
