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
require "test_helper"

class UrlTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
