class Facility < ApplicationRecord
  validates_presence_of :name, :address_1, :city, :state, :zip_code
end
