module RequestHelper
  module JsonHelpers
    def json
      return if response.body.blank?
      @json ||= Oj.load(response.body)
    end
  end
end
