require 'rails_helper'

RSpec.describe AtbsController, type: :controller do
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

    it "should have Attribute effect name" do
      expect(@body_sample[:effect].length).to be > 0
    end

    it "should have Attribute similar count" do
      expect(@body_sample[:count]).to be > 0
    end

    it "should have Attribute target" do
      expect(@body_sample[:target].length).to be > 0
    end
  end
end
