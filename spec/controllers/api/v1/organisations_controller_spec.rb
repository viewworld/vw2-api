require 'rails_helper'

RSpec.describe Api::V1::OrganisationsController, type: :controller do
  let(:sysadmin) { FactoryGirl.create(:user, :sysadmin) }
  let(:admin) { FactoryGirl.create(:user, :admin) }
  let(:user) { FactoryGirl.create(:user, :user) }
  let(:organisation) { FactoryGirl.create(:organisation_with_groups) }

  context 'sysadmin signed in' do
    before(:each) do
      allow(controller).to receive(:current_user).and_return(sysadmin)
    end

    describe 'GET #index' do
      before { 3.times { FactoryGirl.create(:organisation) } }
      it 'returns all organisations as serialized JSON' do
        get :index
        expect(json_response).to be_a(Array)
        expect(json_response.size).to eq 4
      end
    end

    describe 'GET #show' do
      it 'returns organisation as serialized JSON' do
        get_show(sysadmin)
      end
    end
  end

  context 'admin signed in' do
    before(:each) do
      allow(controller).to receive(:current_user).and_return(admin)
    end

    describe 'GET #index' do
      it 'returns an authorization error' do
        get :index
        expect(json_response).to have_key(:errors)
      end
    end

    describe 'GET #show' do
      it 'returns organisation as serialized JSON' do
        get_show(admin)
      end
    end
  end

  context 'user signed in' do
    before(:each) do
      allow(controller).to receive(:current_user).and_return(user)
    end

    describe 'GET #index' do
      it 'returns an authorization error' do
        get :index
        expect(json_response).to have_key(:errors)
      end
    end

    describe 'GET #show' do
      it 'returns organisation as serialized JSON' do
        get_show(user)
      end
    end
  end

  def get_show(user)
    organisation.groups.first.users << user
    get :show, id: organisation.id
    expect(json_response[:name]).to include 'RERA'
    expect(json_response[:groups].length).to eq 5
  end
end
