# Weather App

## Assumptions and choices

- The address input is currently made of two basic fields: a zip code and a
  country, which together form what I call a location.
- I found that I did not need to store any location in the database to meet the
  requirements, so I used a non-database backed location model.
- I ran the slower weather API call out-of-band in a background job, instead of
  in-band inside the request, to keep web server responses fast while allowing
  for background job retries if there are issues. As a result the frontend
  needs to wait for the results of the background job, and I decided to use
  Action Cable because websockets are lighter than traditional polling.

## Getting Started

1. Install dependencies and set up the app:

    ```
    bin/setup --skip-server
    ```

1. [Sign up](https://app.tomorrow.io/signup) for the Tomorrow.io weather API to
   get an API key, and set your `.env` file `TOMORROW_API_KEY` value to your
   API key.

1. Make sure tests pass (everything should be green):

    ```
    bin/rspec
    ```

1. Start the app:

    ```
    bin/dev
    ```

1. You can now access http://localhost:3000 and are ready to go!

## Possible future improvements

- Replace the zip code and country inputs with a single address input that is
  autocompleted and geocoded by a third-party service like Google Maps. Use the
  resulting coordinates to get weather data.
- Locations could be stored in the database if we want to keep historical data.
