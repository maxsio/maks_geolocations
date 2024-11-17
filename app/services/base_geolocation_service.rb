class BaseGeolocationService
  RETRY_LIMIT = 3
  TIMEOUT_SECONDS = 5

  def get_geolocation(query)
    raise NotImplementedError, "#{self.class.name} must implement get_geolocation"
  end

  protected

  def validate!(query)
    raise NotImplementedError, "#{self.class.name} must implement validate!"
  end

  def build_url(query)
    raise NotImplementedError, "#{self.class.name} must implement build_url"
  end

  def fetch_data(url)
    raise NotImplementedError, "#{self.class.name} must implement fetch_data"
  end

  def format_response(data)
    raise NotImplementedError, "#{self.class.name} must implement format_response"
  end
end
