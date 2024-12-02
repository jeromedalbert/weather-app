class WeatherForecastsController < ApplicationController
  def show
    @location = Location.build_from_id(params[:id])
    @location.forecast = Rails.cache.read(@location.id)

    if @location.forecast
      @location.forecast.cached = true
    else
      GetWeatherForecastJob.perform_later(@location.id)
    end
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(location_params)

    if @location.valid?
      redirect_to weather_forecast_path(@location)
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def location_params
    params.expect(location: %i[zip_code country_code])
  end
end
