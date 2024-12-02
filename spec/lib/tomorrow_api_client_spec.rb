require 'rails_helper'

describe TomorrowApiClient do
  describe '#forecast' do
    context 'when provided location is valid', vcr: { cassette_name: 'tomorrow/forecast' } do
      let(:forecast) { TomorrowApiClient.new.forecast(zip_code: '92120', country_code: 'US') }

      it { expect(forecast.success).to eq true }
      it { expect(forecast.full_location_name).to match(/San Diego .* California/) }
      it { expect(forecast.current.temperature).to be_present }
      it { expect(forecast.extended.count).to be >= 3 }
      it { expect(forecast.extended.first.temperatureMin).to be_present }
      it { expect(forecast.extended.first.temperatureMax).to be_present }
    end

    context 'when provided location is invalid',
            vcr: {
              cassette_name: 'tomorrow/forecast_invalid_location'
            } do
      let(:forecast) { TomorrowApiClient.new.forecast(zip_code: 'invalid123', country_code: 'US') }

      it { expect(forecast.success).to eq false }
      it { expect(forecast.error_message).to be_present }
    end
  end
end
