require 'rails_helper'

RSpec.describe Api::V1::ReportsController, type: :controller do
  let(:user) { FactoryGirl.create(:user, :user) }
  let(:admin) { FactoryGirl.create(:user, :admin) }
  let(:organisation) { FactoryGirl.create(:organisation) }
  let(:form) do
    FactoryGirl.create(:form, organisation_id: organisation.id, active: true)
  end
  let(:report) { FactoryGirl.create(:report, form_id: form.id) }

  context 'User.user from same organisation signed in' do
    before(:each) do
      allow(user).to receive(:organisation).and_return(form.organisation)
      allow(controller).to receive(:current_user).and_return(user)
    end

    describe 'GET #index' do
      before { 3.times { FactoryGirl.create(:report, form_id: form.id) } }

      it 'returns all reports associated with form' do
        get :index, form_id: form.id
        expect(json_response).to be_a(Array)
        expect(json_response.size).to eql 3
      end
    end

    describe 'GET #show' do
      it 'returns required report as a serialized JSON' do
        get :show, form_id: form.id, id: report.id
        expect(json_response[:id]).to eql report.id
        expect(json_response[:data]).to be_a(Array)
      end
    end
  end

  context 'User.admin signed in' do
    before(:each) do
      allow(admin).to receive(:organisation).and_return(form.organisation)
      allow(controller).to receive(:current_user).and_return(admin)
    end

    describe 'GET #index' do
      before { 3.times { FactoryGirl.create(:report, form_id: form.id) } }

      it 'returns all forms availible for currently signed in admin' do
        get :index, form_id: form.id
        expect(json_response).to be_a(Array)
        expect(json_response.size).to eql 3
      end
    end

    describe 'GET #show' do
      it 'returns required form as a serialized JSON' do
        get :show, form_id: form.id, id: report.id
        expect(json_response[:id]).to eql report.id
        expect(json_response[:data]).to be_a(Array)
      end
    end

    describe 'POST #create' do
      xit 'creates new form and returns its JSON representation' do
        request.env["CONTENT_TYPE"] = "application/json"
        form = FactoryGirl.attributes_for(:form_data)

        post :create, form, format: 'json'
        puts json_response
        expect(json_response).to_not have_key(:errors)
      end
    end
  end
end
