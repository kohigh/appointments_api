# frozen_string_literal: true

class BaseController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate

  attr_reader :current_user

  rescue_from ActiveRecord::RecordNotFound do
    head 404
  end

  private

  def authenticate
    authenticate_or_request_with_http_token do |token, _|
      user = User.find_by!(token: token)

      @current_user = user
    end
  end
end
