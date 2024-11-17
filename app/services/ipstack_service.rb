require 'net/http'
require 'json'
require 'timeout'

class IpstackService < BaseGeolocationService
  BASE_URL = 'http://api.ipstack.com/'.freeze
  RETRY_LIMIT = 3
  TIMEOUT_SECONDS = 5

  def get_geolocation(query)
    validate!(query)

    url = build_url(query)
    data = fetch_data(url)

    IpstackErrorHandler.handle_errors!(data)
    format_response(data)
  rescue StandardError => e
    { error: "Ipstack Service unavailable", message: e.message }
  end

  private

  def validate!(query)
    raise StandardError, 'Missing IPStack API key' if access_key.blank?
    raise StandardError, 'Query cannot be blank' if query.blank?
    raise StandardError, 'Invalid IP address or URL format' unless IpValidator.valid?(query)
  end

  def build_url(query)
    URI("#{BASE_URL}#{query}?access_key=#{access_key}")
  end

  def fetch_data(url)
    retries = 0
    begin
      Timeout.timeout(TIMEOUT_SECONDS) do
        response = Net::HTTP.get(url)
        JSON.parse(response)
      end
    rescue Timeout::Error, StandardError => e
      retries += 1
      retry if retries < RETRY_LIMIT
      raise e
    end
  end

  def format_response(data)
    {
      ip: data['ip'],
      ip_type: data['ip_type'],
      continent_code: data['continent_code'],
      continent_name: data['continent_name'],
      country_code: data['country_code'],
      country_name: data['country_name'],
      region_code: data['region_code'],
      region_name: data['region_name'],
      city: data['city'],
      zip: data['zip'],
      latitude: data['latitude'],
      longitude: data['longitude']
    }
  end
  
  def access_key
    ENV.fetch('IPSTACK_ACCESS_KEY', nil)
  end
end
