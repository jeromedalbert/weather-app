class GetWeatherForecastJob < ApplicationJob
  def perform(location_id)
    location = Location.build_from_id(location_id)

    location.forecast =
      TomorrowApiClient.new.forecast(
        zip_code: location.zip_code,
        country_code: location.country_code
      )

    Rails.cache.write(location_id, location.forecast, expires_in: 30.minutes)
    location.broadcast_replace
  end
end
