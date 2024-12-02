require 'rails_helper'

describe GetWeatherForecastJob do
  describe '#perform' do
    let(:location) { double.as_null_object }

    before do
      allow(TomorrowApiClient).to receive_message_chain(:new, :forecast)
      allow(Rails.cache).to receive(:write)
      allow(Location).to receive(:new).and_return(location)

      GetWeatherForecastJob.new.perform('92120-US')
    end

    it 'fetches the forecast from the weather API' do
      expect(TomorrowApiClient.new).to have_received(:forecast)
    end

    it 'caches the forecast' do
      expect(Rails.cache).to have_received(:write)
    end

    it 'broadcasts the location forecast to any ActionCable subscribers' do
      expect(location).to have_received(:broadcast_replace)
    end
  end
end
