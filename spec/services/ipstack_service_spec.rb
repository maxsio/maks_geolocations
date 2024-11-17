require 'rails_helper'

RSpec.describe IpstackService do
  let(:service) { described_class.new }
  let(:valid_ip) { '8.8.8.8' }
  let(:test_api_key) { 'test_key' }
  let(:mock_response) do
    {
      'ip' => '8.8.8.8',
      'ip_type' => 'ipv4',
      'continent_code' => 'NA',
      'continent_name' => 'North America',
      'country_code' => 'US',
      'country_name' => 'United States',
      'region_code' => 'CA',
      'region_name' => 'California',
      'city' => 'Mountain View',
      'zip' => '94043',
      'latitude' => 37.422,
      'longitude' => -122.084
    }
  end

  before do
    allow(service).to receive(:access_key).and_return(test_api_key)
  end

  describe '#get_geolocation' do
    context 'when successful' do
      before do
        allow(Net::HTTP).to receive(:get).and_return(mock_response.to_json)
      end

      it 'returns formatted geolocation data' do
        result = service.get_geolocation(valid_ip)
        expect(result[:ip]).to eq('8.8.8.8')
        expect(result[:city]).to eq('Mountain View')
      end
    end

    context 'when API key is missing' do
      before do
        allow(service).to receive(:access_key).and_return(nil)
      end

      it 'returns an error' do
        result = service.get_geolocation(valid_ip)
        expect(result[:error]).to eq('Ipstack Service unavailable')
        expect(result[:message]).to eq('Missing IPStack API key')
      end
    end

    context 'when timeout occurs' do
      before do
        allow(Net::HTTP).to receive(:get).and_raise(Timeout::Error)
      end

      it 'retries and returns error after max attempts' do
        result = service.get_geolocation(valid_ip)
        expect(result[:error]).to eq('Ipstack Service unavailable')
        expect(Net::HTTP).to have_received(:get).exactly(3).times
      end
    end
  end
end