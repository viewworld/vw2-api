require 'rails_helper'

RSpec.describe Api::V1::FormsController, type: :controller do
  let(:user) { FactoryGirl.create(:user, :user) }
  let(:admin) { FactoryGirl.create(:user, :admin) }
  let(:organisation) { FactoryGirl.create(:organisation) }
  let(:form) do
    FactoryGirl.create(:form, organisation_id: organisation.id, active: true)
  end

  context 'User.user from same organisation signed in' do
    before(:each) do
      allow(user).to receive(:organisation).and_return(form.organisation)
      allow(controller).to receive(:current_user).and_return(user)
    end

    describe 'GET #index' do
      before do
        3.times do
          FactoryGirl.create(:form, organisation_id: user.organisation.id,
                                    active: true)
        end
      end

      it 'returns all forms availible for currently signed in user' do
        get :index
        expect(json_response).to be_a(Array)
        expect(json_response.size).to eql 4
      end
    end

    describe 'GET #show' do
      it 'returns required form as a serialized JSON' do
        get :show, id: form.id
        expect(json_response[:id]).to eql form.id
        expect(json_response[:name]).to eql form.name
        expect(json_response[:data]).to be_a(Array)
      end
    end

    describe 'POST #create' do
      it 'returns authorization error' do
        post :create, FactoryGirl.attributes_for(:form)
        expect(json_response).to have_key(:errors)
      end
    end

    describe 'PATCH #update' do
      it 'returns an authorization error' do
        form_attributes = FactoryGirl.attributes_for(:form)
        form_attributes[:id] = form.id
        patch :update, form_attributes
        expect(json_response).to have_key(:errors)
      end
    end

    describe 'DELETE #destroy' do
      it 'returns an authorization error' do
        delete :destroy, id: form.id
        expect(json_response).to have_key(:errors)
      end
    end
  end

  context 'User.admin signed in' do
    before(:each) do
      allow(admin).to receive(:organisation).and_return(form.organisation)
      allow(controller).to receive(:current_user).and_return(admin)
    end

    describe 'GET #index' do
      before do
        3.times do
          FactoryGirl.create(:form, organisation_id: admin.organisation.id,
                                    active: true)
        end
      end

      it 'returns all forms availible for currently signed in admin' do
        get :index
        expect(json_response).to be_a(Array)
        expect(json_response.size).to eql 4
      end
    end

    describe 'GET #show' do
      it 'returns required form as a serialized JSON' do
        get :show, id: form.id
        expect(json_response[:id]).to eql form.id
        expect(json_response[:name]).to eql form.name
        expect(json_response[:data]).to be_a(Array)
      end
    end

    describe 'POST #create' do
      it 'creates new form and returns its JSON representation' do
        request.env["CONTENT_TYPE"] = "application/json"
        form = FactoryGirl.attributes_for(:form)

        post :create, form
        puts json_response
        expect(json_response).to_not have_key(:errors)
      end
    end
  end

  context 'No one signed in' do
  end

  def form_json
    JSON.parse(File.read("#{Rails.root}/spec/factories/form_data.json"))
  end
end
