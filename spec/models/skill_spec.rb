require 'rails_helper'

RSpec.describe Skill, type: :model do
  before :each do
    @hero = Hero.create!(name: 'Test Hero 4',
                     static_name: 'test_hero_4',
                     rank: 4)

    @skill = Skill.new
    @skill.name = "Test Skill 0"
    @skill.category = Skill.categories[:active_0]
    @skill.cooldown = 90
    @skill.static_name = 'test_skill_3_0'
    @skill.hero_id = @hero.id
  end

  context "nullity tests" do
    after :each do
      expect { @skill.save }.to raise_error(ActiveRecord::StatementInvalid)
    end

    it "should have valid name" do
      @skill.name = nil
    end

    # it "should have valid category" do
    #   @skill.category = nil
    # end

    it "should have valid hero reference" do
      @skill.hero_id = nil
    end
  end

  context "validation tests" do
    after :each do
      expect { @skill.save! }.to raise_error(ActiveRecord::StatementInvalid)
    end

    it "should have non-zero cooldown if is an active skill" do
      @skill.cooldown = nil
    end

    it "should have proper static name with both hero rank and skill enumeration" do
      @skill.static_name = 'test_skill'
    end

    it "should have proper static name with both hero rank and skill enumeration" do
      @skill.static_name = 'test_skill_3'
    end

    # it "should have matching inferred category and skill category" do
    #   @skill.static_name = 'test_skill_3_1'
    # end
  end

  context "duplication tests" do
    before :each do
      @skill.save!
      @skill_dup = @skill.dup
    end

    after :each do
      expect { @skill_dup.save! }.to raise_error(ActiveRecord::RecordNotUnique)
    end

    it "should invalidate duplicate skill" do
    end

    it "should invalidate duplicate skill with only different name" do
      @skill.name = "Test Skill 1"
    end

    it "should invalidate duplicate skill with only different static name" do
      @skill.static_name = "test_skill_3_1"
    end

    it "should invalidate duplicate skill with only different category" do
      @skill.category = Skill.categories[:passive]
      @skill.static_name = "test_skill_3_2"
    end
  end

  context "data integrity" do
    before :each do
      @skill.save!
    end

    it "must receive cascading deletion when Hero is destroyed" do
      @hero.destroy
      expect { Skill.find @skill.id }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
