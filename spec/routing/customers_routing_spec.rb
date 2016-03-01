require 'rails_helper'

RSpec.describe Api::V1::CustomersController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get: 'organisations/1/customer')
        .to route_to('api/v1/customers#show', organisation_id: '1')
    end

    it 'routes to #create' do
      expect(post: 'organisations/1/customer')
        .to route_to('api/v1/customers#create', organisation_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: 'organisations/1/customer')
        .to route_to('api/v1/customers#update', organisation_id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: 'organisations/1/customer')
        .to route_to('api/v1/customers#update', organisation_id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: 'organisations/1/customer')
        .to route_to('api/v1/customers#destroy', organisation_id: '1')
    end
  end
end
