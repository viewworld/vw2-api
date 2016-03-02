require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:user_credentials) { { login: user.email, password: 'password' } }
  let(:invalid_user_credentials) do
    { login: user.email, password: 'invalidpassword' }
  end

  describe 'POST#create: when the credentials are correct' do
    it 'returns the user record corresponding to the given credentials' do
      post :create, user_credentials
      @token = json_response[:token]
      user_id = $redis.hget(@token, 'User_id').to_i
      expect(json_response[:id]).to eql user_id
    end

    after(:each) { $redis.hdel(@token, 'User_id') }
  end

  describe 'POST#create: when the credentials are incorrect' do
    it 'returns a json with an error' do
      post :create, invalid_user_credentials
      expect(json_response[:errors]).to eql 'session create error'
    end
  end
end
