#Mammogrammar: Project Synoposis

###Project flow
1. created api based project and excluded testing framework
1. added rspec and shoulda support
1. generated Facility model
1. TDD Facility model
1. TDD FDAFacilityImporter
1. TDD FacilitiesController
1. configured sidekiq w/ redis

###Issues Encountered
1. ActiveRecord::NoEnvironmentInSchemaError
    1. thank you SO... saved again by the wisdom of the masses
    1. just required `except: %w(ar_internal_metadata)` in DatabaseCleaner config
1. Yandex geocoding service... hit quota very quickly
    1. started with yandex because it didn't require an API key
    1. set up a Bing Maps account and that worked way better! ehemm... project instructions;)
