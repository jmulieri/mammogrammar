class FacilitiesController < ApplicationController
  ALLOWED_ZIP_PATTERN =  /^[0-9]{0,5}(-[0-9]{0,4})?$/.freeze

  before_action :verify_nearness_params, only: :near

  def search
    table = Facility.arel_table
    @facilities = Facility.where(table[:zip_code].matches("#{sanitized_zip_code}%"))
    json_response(@facilities)
  end

  def near
    @facilities = Facility.near(params[:location], params[:radius].to_f, latitude: :lat, longitude: :lng)
    json_response(@facilities)
  end

  def sanitized_zip_code
    raise MalformedParameter.new('invalid zip code format') unless ALLOWED_ZIP_PATTERN.match(params[:zip_code])
    params[:zip_code]
  end

  def verify_nearness_params
    unless params.include?('location')
      raise MalformedParameter.new('must provide valid location')
    end
    unless params.include?('radius') && params['radius'].to_f > 0
      raise MalformedParameter.new('must provide valid radius')
    end
  end
end
