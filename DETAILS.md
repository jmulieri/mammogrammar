#Mammogrammar: Project Synoposis

###Project flow
1. created api based project and excluded testing framework
1. added rspec and shoulda support
1. generated Facility model
1. TDD Facility model
1. TDD FDAFacilityImporter
1. import facilities via rake task
1. TDD FacilitiesController
1. configured sidekiq w/ redis
1. TDD FacilityGeolocateJob
1. trigger geoenrichment via 'save' on all facilities
1. add proximity searching and caching
1. created Everscreen (Mammogrammar client) gem with test coverage
1. robustify import to do a sync and only apply changed facilities

###Issues Encountered
1. ActiveRecord::NoEnvironmentInSchemaError
    1. thank you SO... saved again by the wisdom of the masses
    1. just required `except: %w(ar_internal_metadata)` in DatabaseCleaner config
1. Yandex geocoding service... hit quota very quickly
    1. started with yandex because it didn't require an API key
    1. set up a Bing Maps account and that worked way better! ehemm... project instructions;)
1. A few issues with RSpec mocking and expectations
    1. nothing major... but it's been a little while:)

###Summary
All in all, a fun project! I spent about 14 hours total, including dev env setup, etc.
I did complete the bonus and bonus bonus sections. There are quite a few things that
could yet be added if this were going to be a real project, but feel it is at a good spot
for being a sample project. Enjoy!

