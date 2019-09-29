require 'rails_helper'

RSpec.describe 'Facilities API', type: :request do
  let!(:facilities) { create_list(:facility, 10) }
  let(:zip_code) { facilities.first.zip_code }
  let(:absent_zip_code) do
    zips = facilities.map &:zip_code
    zip = Faker::Address.zip_code
    while zips.include? zip
      zip = Faker::Address.zip_code
    end
    zip
  end
  let(:headers) { { 'X-AUTH-TOKEN' => '8f30acc1-e21e-45a8-b9d2-5fb77c933a8f' } }
  let(:invalid_auth_headers) { { 'X-AUTH-TOKEN' => '4dffaa0b-eddf-4f66-b5c5-3e6e119f1bb6' } }

  describe 'GET /search/:zip_code' do
    context 'with no X-AUTH-TOKEN header' do
      before { get "/search/12345-6789" }

      it 'returns appropriate error message' do
        expect(json['message']).to eq('Must provide valid X-AUTH-TOKEN header')
      end

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end

    context 'with an invalid X-AUTH-TOKEN header' do
      before { get "/search/12345-6789", headers: invalid_auth_headers }

      it 'returns appropriate error message' do
        expect(json['message']).to eq('Must provide valid X-AUTH-TOKEN header')
      end

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end

    context 'when facility with zip code exists' do
      before { get "/search/#{zip_code}", headers: headers }

      it 'returns matching facilities' do
        expect(json).not_to be_empty
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when no facilities with zip code exist' do
      before { get "/search/#{absent_zip_code}", headers: headers }

      it 'returns no facilities' do
        expect(json).to be_empty
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when facility exists with matching zip code prefix' do
      before { get "/search/#{zip_code[0..3]}", headers: headers }

      it 'returns matching facilities' do
        expect(json).not_to be_empty
      end
    end

    context 'with malformed zip code' do
      before { get "/search/shaba", headers: headers }

      it 'returns no facilities' do
        expect(json['message']).to eq("invalid zip code format")
      end

      it 'returns status code 400' do
        expect(response).to have_http_status(400)
      end
    end
  end
end