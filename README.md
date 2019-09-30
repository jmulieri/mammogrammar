```
   __     __)                                              
  (, /|  /|                                                
    / | / |  _  ___  ___   ____   __  _  ___  ___   _   __ 
 ) /  |/  |_(_(_// (_// (_(_)(_/_/ (_(_(_// (_// (_(_(_/ (_
(_/   '                     .-/                            
                           (_/                             
```

Simple service to geolocate MQSA Certified Mammography Facilities

### Getting Started
Mammogrammar provides a simple API for finding certified mammography facilities
by zip code. Here is are the steps to get up and running:
1. clone this repository\
`git clone git@github.com:jmulieri/mammogrammar.git`
1. install dependencies\
`cd mammogrammar && bundle install`
1. ensure redis installed and running at localhost:6379
1. start sidekiq for background encoding of geo-coordinates\
`bundle exec sidekiq`
1. import the facilities from the FDA website\
`rake import_fda_facilities`
1. start up the server
`bundle exec rails s`
1. test it out
```bash
# search by zip
curl -H 'X-AUTH-TOKEN: 753574ac-c6aa-4c7e-813e-337c58c70031' "http://localhost:3000/search/95531"

# search by zip prefix
curl -H 'X-AUTH-TOKEN: 753574ac-c6aa-4c7e-813e-337c58c70031' "http://localhost:3000/search/955"

# search by location(zip) and radius
curl -H 'X-AUTH-TOKEN: 753574ac-c6aa-4c7e-813e-337c58c70031' "http://localhost:3000/near?location=96003&radius=99"

# search by location(800 E Washington Blvd, Crescent City, CA 95531) and radius
curl -H 'X-AUTH-TOKEN: 753574ac-c6aa-4c7e-813e-337c58c70031' "http://localhost:3000/near?location=800%20E%20Washington%20Blvd%2C%20Crescent%20City%2C%20CA%2095531&radius=1"
```

