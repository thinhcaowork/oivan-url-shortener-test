class UrlsController < ApplicationController
  include UrlTab
  skip_before_action :verify_authenticity_token
  before_action :validate_parameters

  def encode
    url = Url.find_or_create_url(params[:url])

    if url.errors.any?
      render json: { errors: url.errors.full_messages.join('. ') }
    else
      render json: { shorten_version: url.short }
    end
  end

  def decode
    url = Rails.cache.fetch("#{params[:url]}/decode", expires_in: 24.hours) do
            Url.find_by(short: params[:url])
          end

    if url
      render json: { original_version: url.original }
    else
      header_only(:not_found)
    end
  end

  private

  def validate_parameters
    header_only(:bad_request) unless valid_uri?(params[:url])
  end
end
