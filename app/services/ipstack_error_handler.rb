class IpstackErrorHandler
  class IpstackError < StandardError; end

  ERROR_MESSAGES = {
    404 => 'The requested resource does not exist',
    101 => 'No API Key was specified or an invalid API key was provided',
    102 => 'The current user account is not active',
    103 => 'The requested API endpoint does not exist',
    104 => 'Monthly API request limit exceeded',
    301 => 'One or more invalid fields were specified',
    302 => 'Too many IPs specified for Bulk Lookup (max. 50)',
    303 => 'The Bulk Lookup is not supported on current plan'
  }.freeze

  def self.handle_errors!(data)
    return unless data['success'] === false

    error_code = data.dig('error', 'code')
    message = ERROR_MESSAGES[error_code] || data.dig('error', 'info') || 'Unknown IPStack error'
    raise IpstackError, message
  end
end
