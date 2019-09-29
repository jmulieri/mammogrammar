class ApplicationController < ActionController::API
  class MalformedParameter < StandardError; end
  class NotAuthorized < StandardError; end
  include Response
  include ExceptionHandler

  before_action :authenticate

  def authenticate
    unless request.headers['X-AUTH-TOKEN'] == Rails.configuration.x_auth_token
      raise NotAuthorized.new('Must provide valid X-AUTH-TOKEN header')
    end
  end
end
