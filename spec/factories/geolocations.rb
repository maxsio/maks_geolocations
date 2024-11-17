FactoryBot.define do
  factory :geolocation do
    ip { Faker::Internet.ip_v4_address }
    ip_type { %w[IPv4 IPv6].sample }
    continent_code { 'EU' }
    continent_name { 'Europe' }
    country_code { 'PL' }
    country_name { 'Poland' }
    region_code { 'MZ' }
    region_name { 'Mazovia' }
    city { 'Warsaw' }
    zip { '00-001' }
    latitude { 52.2297 }
    longitude { 21.0122 }
  end
end
