require 'rails_helper'

RSpec.describe SkillsController, type: :controller do
  before :each do
    XlsxInterface.update_database!
  end

  describe 'GET search' do
    before :each do
      get :search, q: 'a'
      @response = response
      @body_sample = JSON.parse(@response.body).first.deep_symbolize_keys
    end

    it "should return status 200" do
      expect(@response.status).to eq(200)
    end

    it "should have Hero name" do
      returned_id = @body_sample[:hero_id]

      expect(Hero.find(returned_id).name).to eq @body_sample[:hero_name]
    end

    it "should have Skill name" do
      returned_id = @body_sample[:skill_id]

      expect(Skill.find(returned_id).name).to eq @body_sample[:skill_name]
    end

    it "should have Hero rank" do
      expect(@body_sample[:hero_rank]).to be > 0
      expect(@body_sample[:hero_rank]).to be <= 6
    end
  end
end
