require 'rails_helper'

RSpec.describe Api::V1::ReportsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: 'forms/1/reports')
        .to route_to('api/v1/reports#index', form_id: '1')
    end

    it 'routes to #show' do
      expect(get: 'forms/1/reports/1')
        .to route_to('api/v1/reports#show', form_id: '1', id: '1')
    end

    it 'routes to #create' do
      expect(post: 'forms/1/reports')
        .to route_to('api/v1/reports#create', form_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: 'forms/1/reports/1')
        .to route_to('api/v1/reports#update', form_id: '1', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: 'forms/1/reports/1')
        .to route_to('api/v1/reports#update', form_id: '1', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: 'forms/1/reports/1')
        .to route_to('api/v1/reports#destroy', form_id: '1', id: '1')
    end
  end
end
