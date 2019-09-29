require 'rails_helper'

RSpec.describe Facility, type: :model do
  include ActiveJob::TestHelper

  let(:facility) { FactoryBot.create :facility }
  let(:facility_with_latlng) { FactoryBot.create(:facility_with_latlng) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:address_1) }
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:state) }
  it { should validate_presence_of(:zip_code) }

  context 'when lat and lng are set' do
    it 'does not trigger callback to set lat/long on save' do
      expect(facility_with_latlng).to_not receive(:enqueue_geolocate_job)
      facility_with_latlng.save
    end
  end

  context 'when lat and lng are set and the address_1 is updated' do
    it 'triggers callback to update lat/long on save' do
      expect(facility_with_latlng).to receive(:enqueue_geolocate_job)
      facility_with_latlng.address_1 += 'foobar'
      facility_with_latlng.save
    end
  end

  context 'when lat and lng are set and the address_2 is updated' do
    it 'triggers callback to update lat/long on save' do
      expect(facility_with_latlng).to receive(:enqueue_geolocate_job)
      facility_with_latlng.address_2 = "#{facility_with_latlng.address_2}foobar"
      facility_with_latlng.save
    end
  end

  context 'when lat and lng are set and the address_3 is updated' do
    it 'triggers callback to update lat/long on save' do
      expect(facility_with_latlng).to receive(:enqueue_geolocate_job)
      facility_with_latlng.address_3 = "#{facility_with_latlng.address_3}foobar"
      facility_with_latlng.save
    end
  end

  context 'when lat and lng are set and the city is updated' do
    it 'triggers callback to update lat/long on save' do
      expect(facility_with_latlng).to receive(:enqueue_geolocate_job)
      facility_with_latlng.city += 'foobar'
      facility_with_latlng.save
    end
  end

  context 'when lat and lng are set and the state is updated' do
    it 'triggers callback to update lat/long on save' do
      expect(facility_with_latlng).to receive(:enqueue_geolocate_job)
      facility_with_latlng.state += 'foobar'
      facility_with_latlng.save
    end
  end

  context 'when lat and lng are set and the zip code is updated' do
    it 'triggers callback to update lat/long on save' do
      expect(facility_with_latlng).to receive(:enqueue_geolocate_job)
      facility_with_latlng.zip_code += 'foobar'
      facility_with_latlng.save
    end
  end

  it 'triggers callback to set lat/long on save' do
    expect(facility).to receive(:enqueue_geolocate_job)
    facility.save
  end

  it 'enqueues job to set lat/long on save' do
    expect {
      facility.save
    }.to have_enqueued_job(FacilityGeolocateJob).with(facility)
  end

  context 'with single line address' do
    let(:facility) { Facility.new(address_1: '123 Main St', city: 'Middleburg', state: 'TX', zip_code: '12345')}
    it 'properly formats address string' do
      expect(facility.address_string).to eq('123 Main St, Middleburg, TX 12345')
    end
  end

  context 'with two line address' do
    let(:facility) { Facility.new(address_1: '123 Main St', address_2: 'Apt 3', city: 'Middleburg', state: 'TX', zip_code: '12345')}
    it 'properly formats address string' do
      expect(facility.address_string).to eq('123 Main St, Apt 3, Middleburg, TX 12345')
    end
  end

  context 'with three line address' do
    let(:facility) do
      Facility.new(address_1: 'Billing Dept', address_2: '123 Main St', address_3: 'Suite 200', city: 'Middleburg', state: 'TX', zip_code: '12345')
    end
    it 'properly formats address string' do
      expect(facility.address_string).to eq('Billing Dept, 123 Main St, Suite 200, Middleburg, TX 12345')
    end
  end
end
