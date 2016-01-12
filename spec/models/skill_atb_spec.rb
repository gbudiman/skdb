require 'rails_helper'

RSpec.describe SkillAtb, type: :model do
  before :each do
    @hero = Hero.create!(name: 'Test Hero', rank: 6, static_name: 'test_hero_6')
    @skill = Skill.create!(name: 'Test Skill 0',
                           category: Skill.categories[:active_0],
                           cooldown: 60,
                           static_name: 'test_skill_6_0',
                           hero_id: @hero.id)
    @atb = Atb.create!(name: 'inflict_electrify_turns',
                       category: Atb.categories[:debuffs])

    @sa = SkillAtb.new(skill_id: @skill.id,
                       atb_id: @atb.id,
                       value: 2,
                       target: SkillAtb.targets[:enemy_all])
  end

  context "nullity tests" do
    after :each do
      expect { @sa.save! }.to raise_error(ActiveRecord::StatementInvalid)
    end

    it "should have valid value" do
      @sa.value = nil
    end

    it "should have valid target" do
      @sa.target = nil
    end

    it "should have valid Skill reference" do
      @sa.skill_id = nil
    end

    it "should have valid Atb reference" do
      @sa.atb_id = nil
    end
  end

  context "duplication tests" do
    before :each do
      @sa.save!
      @sa_dup = @sa.dup
    end

    it "must invalidate duplicate SkillAtb" do
      expect { @sa_dup.save! }.to raise_error(ActiveRecord::RecordNotUnique)
    end

    it "must allow different attribute" do
      atb_alt = @atb.dup
      atb_alt.name = "inflict_different_whatever_turns"
      atb_alt.save!

      @sa_dup.atb_id = atb_alt.id
      expect { @sa_dup.save! }.to change{SkillAtb.count}.by 1
    end

    it "must allow different skill" do
      skill_alt = @skill.dup
      skill_alt.name = "Test Skill 1"
      skill_alt.static_name = "test_skill_6_1"
      skill_alt.category = Skill.categories[:active_1]
      skill_alt.save!

      @sa_dup.skill_id = skill_alt.id
      expect { @sa_dup.save! }.to change{SkillAtb.count}.by 1
    end

    it "must invalidate identical skill and attribute references, even with different value" do
      @sa_dup.value = 3
      expect { @sa_dup.save! }.to raise_error(ActiveRecord::RecordNotUnique)
    end

    it "must invalidate identical skill and attribute references, even with different target" do
      @sa_dup.target = SkillAtb.targets[:enemy_four]
      expect { @sa_dup.save! }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end

  context "data integrity" do
    before :each do
      @sa.save!
    end

    it "must receive cascading deletion when Skill is destroyed" do
      @skill.destroy
      expect { SkillAtb.find @sa.id }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "must receive cascading deletion when Atb is destroyed" do
      @atb.destroy
      expect { SkillAtb.find @sa.id }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
