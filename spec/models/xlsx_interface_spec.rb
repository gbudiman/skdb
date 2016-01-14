require 'rails_helper'

RSpec.describe XlsxInterface, type: :model do
  before :each do
    xlsx = XlsxInterface.new(Rails.root.join('spec', 'xlsx', 'test.xlsx').to_s)
    @data = Importer.new(xlsx.result)
  end

  context "delta detection" do
    it "should have non-zero skill_attributes" do
      expect(@data.stat[:skill_attribute_count]).to be > 0
    end

    it "should reflect recorded Heros count" do
      expect { @data.commit! }.to change{Hero.count}.by(@data.stat[:heros].keys.count)
    end

    it "should reflect recorded Skills count" do
      expect { @data.commit! }.to change{Skill.count}.by(@data.stat[:skills].keys.count)
    end

    it "should reflect recorded Attributes count" do
      expect { @data.commit! }.to change{Atb.count}.by(@data.stat[:attributes].keys.count)
    end

    it "should reflect recorded SkillAttribute count" do
      expect { @data.commit! }.to change{SkillAtb.count}.by(@data.stat[:skill_attribute_count])
    end
  end
end
