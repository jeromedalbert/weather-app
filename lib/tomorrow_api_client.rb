class TomorrowApiClient
  def forecast(zip_code:, country_code:)
    response = fetch_forecast(zip_code, country_code)

    build_forecast(response)
  rescue RestClient::Exception => e
    build_unsuccessful_forecast(e)
  end

  private

  def fetch_forecast(zip_code, country_code)
    EasyRestClient.get(
      'https://api.tomorrow.io/v4/weather/forecast',
      params: {
        location: "#{zip_code} #{country_code}",
        timesteps: '1m,1d',
        units: 'imperial',
        apikey: ENV['TOMORROW_API_KEY']
      }
    )
  end

  def build_forecast(api_response)
    Hashie::Mash.new(
      success: true,
      full_location_name: api_response.location.name,
      current: api_response.timelines.minutely.first['values'],
      extended: extended_forecast(api_response)
    )
  end

  def extended_forecast(api_response)
    api_response.timelines.daily.map { |forecast| forecast['values'].merge(time: forecast.time) }
  end

  def build_unsuccessful_forecast(error)
    Rails.logger.error("ERROR: #{error.message}")

    Hashie::Mash.new(success: false, error_message: 'Error retrieving forecast.')
  end
end
