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
