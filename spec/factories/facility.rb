FactoryBot.define do
  factory :facility do
    name { Faker::Company.name }
    address_1 { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    zip_code { Faker::Address.zip }
    phone { Faker::PhoneNumber }
    fax { Faker::PhoneNumber }
  end
end