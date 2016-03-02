require 'rails_helper'

RSpec.describe XlsxInterface, type: :model do
  before :each do
    xlsx = XlsxInterface.new(Rails.root.join('spec', 'xlsx', 'test.xlsx').to_s)
    @data = Importer.new(xlsx)
  end

  context "delta detection" do
    it "should have non-zero skill_attributes" do
      expect(@data.result_skills[:skill_attribute_count]).to be > 0
    end

    it "should reflect recorded Heros count" do
      expect { @data.commit! }.to change{Hero.count}.by(@data.result_skills[:heros].keys.count)
    end

    it "should reflect recorded Skills count" do
      expect { @data.commit! }.to change{Skill.count}.by(@data.result_skills[:skills].keys.count)
    end

    it "should reflect recorded Attributes count" do
      expect { @data.commit! }.to change{Atb.count}.by(@data.result_skills[:attributes].keys.count)
    end

    it "should reflect recorded SkillAttribute count" do
      expect { @data.commit! }.to change{SkillAtb.count}.by(@data.result_skills[:skill_attribute_count])
    end

    it "should reflect recorded Hero Stat count" do
      expect { @data.commit! }.to change{Stat.count}.by(@data.result_stats[:expected_row_change])
    end
  end
end
