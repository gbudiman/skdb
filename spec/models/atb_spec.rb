require 'rails_helper'

RSpec.describe Skill, type: :model do
  before :each do
    @atb = Atb.new
  end

  context "inline parsing should be able to detect modifier" do
    {"inflict_turns_something" => "turns",
     "inflict_fraction_of_magical_attack" => "fraction",
     "inflict_amount_of_whatever" => "amount",
     "inflict_burn_probability" => "probability",
     "inflict_whatever_hit_count" => "hit_count"}.each do |k, v|
      it "#{v}" do
        @atb.name = k
        @atb.parse
        expect(@atb.modifier).to eq(v) 
      end
    end
  end

  context "invalid modifier" do
    it "should raise StatementInvalid" do
      @atb.name = "whatever_modifier_that_should_be_invalid"
      expect { @atb.parse }.to raise_error(ActiveRecord::StatementInvalid)
    end
  end

  context "with properly parsed modifier" do
    before :each do
      @atb.name = "inflict_burn_turns"
      @atb.parse
      @atb.category = Atb.categories[:debuffs]
    end

    context "nullity tests" do
      after :each do
        expect { @atb.save! }.to raise_error(ActiveRecord::StatementInvalid)
      end

      it "should have valid name" do
        @atb.name = nil
      end

      # it "should have valid category" do
      #   @atb.category = nil
      # end
    end

    context "duplication tests" do
      before :each do
        @atb.save!
        @atb_dup = @atb.dup
      end

      it "should invalidate duplicate attribute" do
        expect { @atb_dup.save! }.to raise_error(ActiveRecord::RecordNotUnique)
      end

      it "should allow attribute with different name" do
        @atb_dup.name = "inflict_burn_fraction_of_physical_attack"
        expect { @atb_dup.save! }.to change{Atb.count}.by 1
      end
    end
  end
end
