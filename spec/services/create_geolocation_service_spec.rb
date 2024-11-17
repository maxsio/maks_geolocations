require 'rails_helper'

RSpec.describe CreateGeolocationService do
  let(:url) { '8.8.8.8' }
  let(:service_name) { 'ipstack' }
  let(:mock_geolocation_data) do
    {
      ip: '8.8.8.8',
      city: 'Mountain View',
      country_name: 'United States'
    }
  end
  let(:mock_service) { instance_double('IpstackService') }

  before do
    allow(GeolocationServiceFactory).to receive(:for).with(service_name).and_return(mock_service)
    allow(mock_service).to receive(:get_geolocation).with(url).and_return(mock_geolocation_data)
  end

  describe '.call' do
    before { Geolocation.delete_all }

    it 'creates a new geolocation record if it does not exist' do
      expect {
        described_class.call(url, service_name)
      }.to change(Geolocation, :count).by(1)
    end

    it 'returns existing geolocation if it exists' do
      existing = Geolocation.create!(mock_geolocation_data)
      
      result = described_class.call(url, service_name)
      
      expect(result).to eq(existing)
      expect(mock_service).not_to have_received(:get_geolocation)
      expect(Geolocation.count).to eq(1)
    end

    it 'uses the correct service from factory' do
      described_class.call(url, service_name)
      expect(GeolocationServiceFactory).to have_received(:for).with(service_name)
    end
  end
end