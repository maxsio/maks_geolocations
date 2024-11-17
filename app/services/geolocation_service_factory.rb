class GeolocationServiceFactory
  class << self
    attr_writer :default_service

    def default_service
      @default_service ||= :ipstack
    end

    def register_service(name, service_class)
      services[name] = service_class
    end

    def for(service_name = nil)
      service_class = services[service_name || default_service]
      raise(ArgumentError, "Unknown geolocation service: #{service_name}") unless service_class

      service_class.new
    end

    private

    def services
      @services ||= {
        ipstack: IpstackService
      }
    end
  end
end
