FactoryBot.define do
  factory :url do
    original { "#{ENV['shorten_host']}/test_original_link" }
    short {
      %Q(#{ENV['shorten_host']}#{([*("a".."z"),*("A".."Z"),*("0".."9")]).sample(Url::SHORT_ID_LENGTH).join })
    }
  end
end
