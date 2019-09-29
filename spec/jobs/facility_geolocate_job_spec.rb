require 'rails_helper'

RSpec.describe FacilityGeolocateJob, type: :job do
  include ActiveJob::TestHelper

  subject(:job) { described_class.perform_later(facility) }
  let(:facility) { FactoryBot.create :facility }
  let(:lat_lng) { [ 37.50, -122.50 ] }

  it 'queues the job' do
    expect { job }.to have_enqueued_job(described_class)
      .with(facility)
      .on_queue("default")
  end

  it 'performs geocoding of facility address' do
     expect(Geocoder).to receive(:coordinates).with(facility.address_string)
     perform_enqueued_jobs { job }
  end

  it 'updates facility lat and lng attributes' do
    expect(Geocoder).to receive(:coordinates).with(facility.address_string).and_return(lat_lng)
    expect(Facility.find(facility.id).lat).to eq(nil)
    expect(Facility.find(facility.id).lng).to eq(nil)
    perform_enqueued_jobs { job }
    expect(Facility.find(facility.id).lat).to eq(lat_lng.first)
    expect(Facility.find(facility.id).lng).to eq(lat_lng.last)
  end
end

