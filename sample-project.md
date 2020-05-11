# Back Story

We're in the process of doing some major updates to one of our apps. The app was built for a client of ours to help women fight Breast Cancer through early detection.

One of the major features of is the ability for a user to search for clinics near them. Currently, the core of this functionality is provided by [Yelp](http://www.yelp.com/) - which was a great solution when we first launched.

We've found though, that Yelp can return undesired results - as well as provide a layer of complexity for our client (ex: clinics have contacted them directly to be added to the search results, but our client doesn't have control over them - as they are provided by Yelp).

As such, we researched some alternate solutions and found that The FDA has a list of Certified Mammogram Facilities that they manage and are updated weekly. This is a big win!

The downside to this, though, is that they won't give us access to their API. `#sadface`

Instead, they've given us a link to a zipped text file of the data.

[You can find their web search here](http://www.fda.gov/Radiation-EmittingProducts/MammographyQualityStandardsActandProgram/ConsumerInformation/ucm113962.htm), the direct link to the zipped file can be found on that page.

Ideally, we'll end up replacing Yelp with an alternate API (or something equivalent) that we provide from using The FDA's list of clinics.

# Your Mission

We want you to build a simple API that when given a zip code, it returns the list of clinics from that zip code.

The clinics will be populated from the data provided by The FDA.

## Requirements

- Build a Rails App that acts as a JSON API to receive a zip code, and return the clinics associated with that code.
- The Rails App must have a Rake task that, when run, will use a service class [^1] to:
    1. Hit the FDA's file endpoint.
    2. Download the zipped text file into memory.
    3. Unzip and parse the text file, and then sync the clinics to the database.
    4. Note: Expect this rake task to be run regularly (ie: nightly).
- When Clinics are created, the app should find the Clinic's latitude and longitude using a Geocoding API[^2].
- The Rails App must provide an API endpoint that:
    1. Checks for an `X-Auth-Token` in the header of the request, ensuring that it matches a configured Environment Variable on the server.
        - This will prevent unauthorized requests to the API.
    2. When given a zipcode, returns the clinics for that location in a JSON format.
- Build a _simple_ Ruby gem that can be used in a project to hit the Rails app and get the clinic data back.
    1. The gem should have a [`configure`](http://brandonhilkert.com/blog/ruby-gem-configuration-patterns/) option, to:
        - Give it the endpoint of the API (ex: where it lives on the internet).
        - Give it the `auth_token` used in the `X-Auth-Token` header for the request.
    2. The gem just has to provide a simple way for hitting the Rails app and returning the JSON
    3. NOTE: Don't register the gem with RubyGems.org
- Have a detailed explanation of setup / usage in the README(s) of the project(s)
- Tests are not a feature, they are a *requirement*.
- Use our [Rubycop config](https://github.com/detaso/style/blob/master/ruby/.rubocop.yml) to validate your code.
- Provide a `DETAILS.md` file with your process of solving these problems, snags you hit, things you learned, etc along with the number of hours required to finish the task.

## Bonus Points

- Offloading the lat/long portion to background workers, such as ActiveJob or Sidekiq.
- Caching with Redis

## Bonus Bonus Points

- Add to the API / gem an ability to find clinics based on a given radius to the zipcode (ie: all clinics within X miles of 72034)

## Additional Info

We've tried to give you enough information to introduce the business need, without completely holding your hand. This task is more than just whether you can code, but also if you can think through the business case of what you're building.

----

[^1]: Meaning this functionality shouldn't all live in the Rakefile. The task itself should delegate to a Ruby service (ex: `ClinicFetcher`).

[^2]: There are multiple options for Geocoding APIs that you can look into, however - lots of them have rate limits (there are just over 8k clinics in the list)
  - Start with [Bing's Location API](https://prazjain.wordpress.com/2009/07/24/using-virtual-earth-bing-geocoding-webservice/), apparently they allow 30k transactions / day. If that doesn't work - let us know.