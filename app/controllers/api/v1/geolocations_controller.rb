module Api
  module V1
    class GeolocationsController < ApplicationController
      before_action :set_geolocation, only: %i[show destroy]

      def show
        render json: @geolocation
      end

      def create
        geolocation = CreateGeolocationService.call(geolocation_params[:url])
        render json: geolocation, status: :created
      rescue StandardError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      def destroy
        @geolocation.destroy
        head :no_content
      end

      private

      def set_geolocation
        @geolocation = Geolocation.find(params[:id])
      end

      def geolocation_params
        params.permit(:url)
      end
    end
  end
end
