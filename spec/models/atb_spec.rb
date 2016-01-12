require 'rails_helper'

RSpec.describe Skill, type: :model do
  before :each do
    @atb = Atb.new
  end

  context "inline parsing should be able to" do
    {"inflict_turns_something" => ["turns", "inflict_something"],
     "inflict_fraction_of_magical_attack" => ["fraction", "inflict_magical_attack"],
     "inflict_amount_of_whatever" => ["amount", "inflict_whatever"],
     "inflict_burn_probability" => ["probability", "inflict_burn"],
     "inflict_whatever_hit_count" => ["hit_count", "inflict_whatever"]}.each do |k, r|
      
      it "detect modifier #{r[0]}" do
        @atb.name = k
        @atb.parse
        expect(@atb.modifier).to eq(r[0]) 
      end

      it "detect effect #{r[1]}" do
        @atb.name = k
        @atb.parse
        expect(@atb.effect).to eq(r[1])
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
