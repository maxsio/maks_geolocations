class ApplicationController < ActionController::API
  rescue_from ActiveRecord::ConnectionTimeoutError, with: :handle_database_error
  rescue_from ActiveRecord::ConnectionNotEstablished, with: :handle_database_error
  rescue_from JSON::ParserError, with: :handle_invalid_json
  rescue_from ActionController::ParameterMissing, with: :handle_missing_params
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
  rescue_from ActionDispatch::Http::Parameters::ParseError, with: :handle_invalid_request

  private

  def handle_database_error
    render json: { error: 'Database is temporarily unavailable' }, status: :service_unavailable
  end

  def handle_invalid_json
    render json: { error: 'Invalid response from geolocation service' }, status: :service_unavailable
  end

  def handle_missing_params
    render json: { error: 'Missing required parameters' }, status: :bad_request
  end

  def handle_not_found
    render json: { error: 'Resource not found' }, status: :not_found
  end

  def handle_invalid_request
    render json: { error: 'Invalid request format' }, status: :bad_request
  end
end
