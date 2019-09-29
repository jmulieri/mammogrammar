class FacilitiesController < ApplicationController
  ALLOWED_ZIP_PATTERN =  /^[0-9]{0,5}(-[0-9]{0,4})?$/.freeze

  def search
    table = Facility.arel_table
    @facilities = Facility.where(table[:zip_code].matches("#{sanitized_zip_code}%"))
    json_response(@facilities)
  end

  def sanitized_zip_code
    raise MalformedParameter.new('invalid zip code format') unless ALLOWED_ZIP_PATTERN.match(params[:zip_code])
    params[:zip_code]
  end
end
