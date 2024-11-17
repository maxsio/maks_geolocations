class CreateGeolocationService
  def self.call(url, service_name = nil)
    new(url, service_name).call
  end

  def initialize(url, service_name = nil)
    @url = url
    @service_name = service_name
  end

  def call
    existing_geolocation = Geolocation.find_by(ip: @url)
    return existing_geolocation if existing_geolocation

    service = GeolocationServiceFactory.for(@service_name)
    geolocation_data = service.get_geolocation(@url)
    Geolocation.create!(geolocation_data)
  end
end
