require 'rails_helper'

describe WeatherForecastsController do
  describe '#show' do
    before { allow(GetWeatherForecastJob).to receive(:perform_later) }

    context 'when forecast is not cached' do
      before { get :show, params: { id: '92120-US' } }

      it { should respond_with :ok }
      it { expect(GetWeatherForecastJob).to have_received(:perform_later) }
    end

    context 'when forecast is cached' do
      before do
        Rails.cache.write('92120-US', Hashie::Mash.new)

        get :show, params: { id: '92120-US' }
      end

      it { should respond_with :ok }
      it { expect(GetWeatherForecastJob).not_to have_received(:perform_later) }
    end
  end

  describe '#new' do
    before { get :new }

    it { should respond_with :ok }
  end

  describe '#create' do
    context 'when params are invalid' do
      before { post :create, params: { location: { zip_code: '' } } }

      it { should respond_with :unprocessable_content }
    end

    context 'when params are valid' do
      before { post :create, params: { location: { zip_code: '92120', country_code: 'US' } } }

      it { should redirect_to weather_forecast_path('92120-US') }
    end
  end
end
