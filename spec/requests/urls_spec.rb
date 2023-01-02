require 'rails_helper'

RSpec.describe 'Urls', type: :request do
  let(:valid_url) { "http://example.co.jp/test_api" }
  let(:invalid_url) { "invalid_http_link"}

  describe 'POST /encode' do
    subject { post encode_path, params: params }

    context 'invalid params' do
      let(:params) { { url: invalid_url } }

      it 'should respond 400 status code' do
        subject
        expect(response.status).to eq(400)
      end
    end

    context 'valid params' do
      context 'non existed url' do
        let(:params) { { url: valid_url } }

        it 'should create and respond a new shortened url' do
          expect{ subject }.to change{ Url.count }.by(1)
          created_url = Url.order(created_at: :desc).first
          expect(json['shorten_version']).to eq(created_url.short)
        end
      end

      context 'existed url' do
        let!(:url) { create(:url) }
        let(:params) { { url: url.original } }

        it 'should not create new url and respond existed shortened url' do
          expect{ subject }.not_to change{ Url.count }
          expect(json['shorten_version']).to eq(url.short)
        end
      end
    end
  end

  describe 'GET /decode' do
    subject { get decode_path, params: params }

    context 'invalid params' do
      let(:params) { { url: invalid_url } }

      it 'should respond 400 status code' do
        subject
        expect(response.status).to eq(400)
      end
    end

    context 'valid params' do
      context 'non existed url' do
        let(:params) { { url: valid_url } }

        it 'should respond 404 status code' do
          subject
          expect(response.status).to eq(404)
        end
      end

      context 'existed url' do
        let!(:url) { create(:url) }
        let(:params) { { url: url.short } }

        it 'should respond existed original url' do
          subject
          expect(json['original_version']).to eq(url.original)
        end
      end
    end
  end
end
