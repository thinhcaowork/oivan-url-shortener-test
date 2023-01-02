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
require 'rails_helper'

RSpec.describe Url, type: :model do
  describe 'Validation' do
    it { should validate_presence_of(:original) }
    it { should validate_presence_of(:short) }
    it { should validate_uniqueness_of(:original) }
    it { should validate_uniqueness_of(:short) }
    it do
      should validate_length_of(:original).is_at_least(3)
                                          .is_at_most(255)
                                          .with_message(/too long/)
    end
    it do
      should validate_length_of(:short).is_at_least(3)
                                          .is_at_most(255)
                                          .with_message(/too long/)
    end
  end

  describe 'find_or_create_url method' do
    context 'url existed' do
      let!(:url) { create(:url) }

      it 'shoud not change Url count' do
        expect { Url.find_or_create_url(url.original) }.not_to change { Url.count }
      end
    end

    context 'url non exists' do
      it 'shoud not change Url count' do
        expect {
          Url.find_or_create_url("https://test.com/#{SecureRandom.hex(6)}")
        }.to change { Url.count }.by(1)
      end
    end
  end

  describe 'create_url_with_shorten_version method' do
    let(:url_param) { "#{ENV['shorten_host']}test_url_param'" }

    it 'should change Url count by 1' do
      expect {
        Url.create_url_with_shorten_version(url_param)
      }.to change { Url.count }.by(1)
    end
  end
end
