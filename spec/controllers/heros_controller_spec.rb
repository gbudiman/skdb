require 'rails_helper'

RSpec.describe HerosController, type: :controller do
  before :each do
    XlsxInterface.update_database!
    @hero_id = Hero.ids[Random.new.rand(Hero.count-1)]
  end

  describe "GET fetch" do
    before :each do
      get :view_fetch, id: @hero_id
      @response = response
      @body = JSON.parse(@response.body).first.deep_symbolize_keys
    end

    it "should return status 200" do
      expect(@response.status).to eq(200)
    end

    it "should have Hero name" do
      expect(@body[:hero_name]).to eq Hero.find(@hero_id).name
    end

    it "should have non-zero skills" do
      expect(@body[:skills].keys.length).to be > 0
    end

    it "should have active_0 skill with non-zero length attributes and modifiers" do
      first_attribute = @body[:skills][:active_0][:attributes].values.first
      expect(first_attribute[:modifiers].keys.length).to be > 0
    end
  end

  describe "GET search" do
    before :each do
      get :search, q: 'a'
      @response = response
      @body_sample = JSON.parse(@response.body).first.deep_symbolize_keys
    end

    it "should return status 200" do
      expect(@response.status).to eq(200)
    end

    it "should have Hero id" do
      expect(@body_sample[:id]).to be > 0
    end

    it "should have Hero name" do
      expect(@body_sample[:name].length).to be > 0
    end

    it "should have rank between 1 and 6 inclusive" do
      expect(@body_sample[:rank]).to be >  0 
      expect(@body_sample[:rank]).to be <= 6
    end
  end

  describe "GET having ATB effect" do
    before :each do
      get :fetch_having_atb_effect, n: 'attack_physical'
      @response = response
      @body_sample = JSON.parse(@response.body).first.deep_symbolize_keys
    end

    it "should return 1 or more rows" do
      expect(@response.body.length).to be > 0
    end

    it "should return status 200" do
      expect(@response.status).to eq(200)
    end

    # remaining tests are similar to GET fetch
  end
end
