require 'uri'
require 'ipaddr'

class IpValidator
  def self.valid?(query)
    valid_ip?(query) || valid_url?(query)
  end

  def self.valid_ip?(ip)
    IPAddr.new(ip)
    true
  rescue IPAddr::InvalidAddressError
    false
  end

  def self.valid_url?(url)
    uri = URI.parse(url)
    uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
  rescue URI::InvalidURIError
    false
  end
end
