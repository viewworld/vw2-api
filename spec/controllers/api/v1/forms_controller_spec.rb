require 'rails_helper'

RSpec.describe Api::V1::FormsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }

  context 'User signed in' do
    before(:each) do
      allow(controller).to receive(:current_user).and_return(user)
    end
  end
end
