require 'swagger_helper'

RSpec.describe 'Api::V1::Geolocations', type: :request do
  path '/api/v1/geolocations/{id}' do
    get 'Retrieves a geolocation' do
      tags 'Geolocations'
      description 'Returns a single geolocation by ID'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'Geolocation ID'

      response '200', 'geolocation found' do
        schema '$ref' => '#/components/schemas/geolocation'
        let(:geolocation) { create(:geolocation) }
        let(:id) { geolocation.id }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['ip']).to eq(geolocation.ip)
        end
      end

      response '404', 'geolocation not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    delete 'Deletes a geolocation' do
      tags 'Geolocations'
      description 'Deletes a specific geolocation'
      parameter name: :id, in: :path, type: :string, description: 'Geolocation ID'

      response '204', 'geolocation deleted' do
        let(:geolocation) { create(:geolocation) }
        let(:id) { geolocation.id }
        run_test!
      end
    end
  end

  path '/api/v1/geolocations' do
    post 'Creates a geolocation' do
      tags 'Geolocations'
      description 'Creates a new geolocation from IP or URL'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :url, in: :body, schema: {
        type: :object,
        properties: {
          url: { type: :string, description: 'IP address or URL to geolocate' }
        },
        required: [:url]
      }

      response '201', 'geolocation created' do
        let(:mock_geolocation) { build(:geolocation) }
        let(:url) { { url: '8.8.8.8' } }

        before do
          allow(CreateGeolocationService).to receive(:call)
            .with('8.8.8.8')
            .and_return(mock_geolocation)
        end

        run_test! do |response|
          expect(CreateGeolocationService).to have_received(:call).with('8.8.8.8')
        end
      end

      response '422', 'invalid request' do
        let(:url) { { url: 'invalid-url' } }
        
        before do
          allow(CreateGeolocationService).to receive(:call)
            .with('invalid-url')
            .and_raise(StandardError.new('Invalid URL format'))
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['error']).to eq('Invalid URL format')
        end
      end
    end
  end
end
