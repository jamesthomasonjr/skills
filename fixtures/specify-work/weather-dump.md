# Weather page — thought process

I want a weather page.

MVP: a single page that shows today’s weather for the user’s location.

To achieve it I need to get the location, maybe today’s date, fetch the weather, and display it.

Classes later:

- LocationProvider → UserLocationProvider (later we might take location from a URL query)
- DateProvider → TodaysDateProvider (maybe unnecessary)
- WeatherProvider → ServiceOfChoice (picking the service is still open)

Plan: small stacked PRs on GitHub. Each PR is one interface + implementation + tests, plus a mock of that interface for dependents. Follow SOLID. Use ISP.

Later we will want 3-day, 7-day, and 10-day forecasts. That means day vs range methods: narrow interfaces SingleDateProvider and DateRangeProvider, and a fat DateProvider that implements both. Separate from MVP. Location from a URL query is also later, not MVP.

Please spec this, design the classes, and plan the implementation. ISP, SOLID, and stacked PRs are required.
