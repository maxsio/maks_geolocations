# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Geolocation.find_or_create_by!(ip: '134.201.250.155') do |geo|
  geo.ip_type = 'ipv4'
  geo.continent_code = 'NA'
  geo.continent_name = 'North America'
  geo.country_code = 'US'
  geo.country_name = 'United States'
  geo.region_code = 'CA'
  geo.region_name = 'California'
  geo.city = 'Los Angeles'
  geo.zip = '90013'
  geo.latitude = 34.04563903808594
  geo.longitude = -118.24163818359375
end

Geolocation.find_or_create_by!(ip: '172.68.50.243') do |geo|
  geo.ip_type = 'ipv4'
  geo.continent_code = 'EU'
  geo.continent_name = 'Europe'
  geo.country_code = 'AT'
  geo.country_name = 'Austria'
  geo.region_code = '9'
  geo.region_name = 'Vienna'
  geo.city = 'Vienna'
  geo.zip = '1000'
  geo.latitude = 48.20861053466797
  geo.longitude = 16.374170303344727
end
