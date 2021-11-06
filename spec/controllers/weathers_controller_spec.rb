require 'rails_helper'
require 'webmock/rspec'

RSpec.describe WeathersController, type: :controller do

  describe "GET #health" do
    it 'render_ok_answer' do
      get :health
      expect(JSON.parse(response.body)).to eq({"status" => "OK"})
    end
  end
      
  describe "GET #max_temp_last_24" do
  # before(:each) do
  #   VCR.insert_cassette("answer") {WeathersController}
  # end
  
    it 'get cassette' do
      VCR.use_cassette("answer") {WeathersController}
    end

    it 'return hash a metric' do
      VCR.use_cassette("answer") {WeathersController}
      get :max_temp_last_24
    end
    

  end
end
