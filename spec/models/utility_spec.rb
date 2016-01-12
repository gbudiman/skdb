require 'rails_helper'

RSpec.describe Utility, type: :model do
  context "strip_static_name_to_hero" do
    it "must raise exception when static_name is not in form \\w+_\\d_\\d" do
      expect { Utility::strip_static_name_to_hero "test_hero" }.to raise_error(NameError)
      expect { Utility::strip_static_name_to_hero "test_hero_6" }.to raise_error(NameError)
      expect { Utility::strip_static_name_to_hero "test_hero_6_5_4" }.to raise_error(NameError)
    end

    it "must return correct static_name reduced to hero" do
      expect(Utility::strip_static_name_to_hero "test_hero_6_2").to eq("test_hero_6")
    end
  end

  context "mask_hero_rank_in_static_name" do
    it "must return correct static_name with hero_rank masked" do
      expect(Utility::mask_hero_rank_in_static_name "test_hero_6_2").to eq("test_hero_x_2")
    end
  end
end
