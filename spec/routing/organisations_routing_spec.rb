require 'rails_helper'

RSpec.describe Api::V1::OrganisationsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: 'organisations')
        .to route_to('api/v1/organisations#index')
    end

    it 'routes to #show' do
      expect(get: '/organisations/1')
        .to route_to('api/v1/organisations#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/organisations')
        .to route_to('api/v1/organisations#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/organisations/1')
        .to route_to('api/v1/organisations#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/organisations/1')
        .to route_to('api/v1/organisations#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/organisations/1')
        .to route_to('api/v1/organisations#destroy', id: '1')
    end
  end
end
