module UrlTab
  extend ActiveSupport::Concern

  protected

  def valid_uri?(url)
    uri = URI.parse(url)
    %w(http https).include?(uri.scheme)
  rescue URI::BadURIError
    false
  rescue URI::InvalidURIError
    false
  end
end
