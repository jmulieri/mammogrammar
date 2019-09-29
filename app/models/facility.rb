require 'geocoder/stores/active_record'

class Facility < ApplicationRecord
  include Geocoder::Store::ActiveRecord

  validates_presence_of :name, :address_1, :city, :state, :zip_code
  after_save :enqueue_geolocate_job, if: :requires_geocoding?

  def address_string
    "#{address_1}, #{"#{address_2}, " if address_2}#{"#{address_3}, " if address_3}#{city}, #{state} #{zip_code}"
  end

  private

  def enqueue_geolocate_job
    FacilityGeolocateJob.perform_later(self)
  end

  def requires_geocoding?
    lat.nil? || lng.nil? || address_changed?
  end

  def address_changed?
    ( saved_change_to_address_1? ||
      saved_change_to_address_2? ||
      saved_change_to_address_3? ||
      saved_change_to_city?      ||
      saved_change_to_state?     ||
      saved_change_to_zip_code? )
  end
end
