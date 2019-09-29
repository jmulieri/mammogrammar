class FacilityGeolocateJob < ApplicationJob
  queue_as :default

  def perform(facility)
    # Geocoder::Calculations.distance_between([46.597476, -120.529686], [46.59379, -120.552636]) => dist_in_miles
    # Geocoder.coordinates(address) => [lat, long]
    begin
      lat,lng = Geocoder.coordinates(facility.address_string)
      if lat.present? && lng.present?
        facility.lat = lat
        facility.lng = lng
        facility.save
      end
    rescue Exception => e
      Rails.logger.error("Error in FacilityGelocateJob#perform while encoding #{facility.address_string}: #{e.message}")
      # re-raise to let ActiveJob's retry mechanism take over
      raise e
    end
  end
end
