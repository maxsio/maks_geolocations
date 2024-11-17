require 'rails_helper'

RSpec.describe Geolocation do
  let(:geolocation) { build(:geolocation) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(geolocation).to be_valid
    end

    it 'is not valid without a ip' do
      geolocation.ip = nil
      expect(geolocation).not_to be_valid
    end

    it 'is not valid with a duplicate ip' do
      create(:geolocation, ip: '8.8.8.8')
      new_geolocation = build(:geolocation, ip: '8.8.8.8')
      expect(new_geolocation).not_to be_valid
    end
  end
end
