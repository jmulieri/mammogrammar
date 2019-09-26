#Mammogrammar: Project Synoposis

###Project flow
1. created api based project and excluded testing framework
1. added rspec and shoulda support
1. generated Facility model
1. TDD Facility model

###Issues Encountered
1. ActiveRecord::NoEnvironmentInSchemaError
    1. thank you SO... saved again by the wisdom of the masses
    1. just required `except: %w(ar_internal_metadata)` in DatabaseCleaner config