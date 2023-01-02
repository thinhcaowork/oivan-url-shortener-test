class UrlsController < ApplicationController
  include UrlTab
  skip_before_action :verify_authenticity_token

  def encode
    return header_only(:bad_request) unless valid_uri?(params[:url])

    url = Url.find_or_create_url(params[:url])

    if url.errors.any?
      render json: { errors: url.errors.full_messages.join('. ') }
    else
      render json: { shorten_version: url.short }
    end
  end
end
