# == Schema Information
#
# Table name: urls
#
#  id         :bigint           not null, primary key
#  original   :text
#  short      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_urls_on_original  (original) UNIQUE
#  index_urls_on_short     (short) UNIQUE
#
class Url < ApplicationRecord
  SHORT_ID_LENGTH = 6
  validates_presence_of :original
  validates :original, format: URI::regexp(%w[http https])
  validates_uniqueness_of :short
  validates_length_of :original, within: 3..255, on: :create, message: "too long"
  validates_length_of :short, within: 3..255, on: :create, message: "too long"

  class << self
    def find_or_create_url(url)
      existed_url = find_by(original: url)
      return create_url_with_shorten_version(url) unless existed_url

      existed_url
    end

    def create_url_with_shorten_version(url)
      loop do
        unique_id = ([*("a".."z"),*("A".."Z"),*("0".."9")]).sample(SHORT_ID_LENGTH).join
        shorten_url = "#{ENV['shorten_host']}#{unique_id}"
        break create(original: url, short: shorten_url) unless exists?(short: shorten_url)
      end
    end
  end
end
