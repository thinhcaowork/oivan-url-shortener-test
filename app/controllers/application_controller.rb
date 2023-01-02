class ApplicationController < ActionController::Base
  def header_only(status)
    head(status, content_type: 'application/json; charset=utf-8')
  end
end
