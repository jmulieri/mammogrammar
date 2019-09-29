require 'rails_helper'
require 'fda_facility_importer'
require 'zip'

RSpec.describe FDAFacilityImporter do
  let(:fda_facility_importer) { FDAFacilityImporter.new }
  let(:row1) { ['325th Medical Group /Diagnostic Imaging Dept', '340 Magnolia Circle', nil, nil, 'Tyndall AFB', 'FL', '32403-5612', '850283-7541', '850283-7634'] }
  let(:row2) { ['35th Medical Group Misawa AB Japan', 'Unit 5024', nil, nil, 'APO', 'AP', '96319-5300', '813117776602', '8117677'] }
  let(:row3) { ['366 Medical Group/Diagnostic Imaging', '90 Hope Dr Bldg 6000', '366 Medical Group  ACC /Rad Dept SGSQ', nil, 'Mountain Home AFB', 'ID', '83648-5300', '208828-7810', '208828-3793'] }
  let(:rows) { [row1, row2, row3] }
  let(:contents) { rows.map { |r| r.join('|') }.join("\n") }
  let(:zip) do
    os = StringIO.new
    os.set_encoding Encoding::ASCII_8BIT
    Zip::OutputStream.write_buffer(os) do |z|
      z.put_next_entry('public.txt')
      z.write(contents)
    end
    os.rewind
    os.read
  end
  let(:zip_buffer) { StringIO.new(zip) }
  let(:fda_url) { 'http://www.accessdata.fda.gov/premarket/ftparea/public.zip' }
  let(:response_body) { zip }
  let(:response) { instance_double(HTTParty::Response, body: response_body) }

  describe '#fetch_zip' do
    before do
      allow(HTTParty).to receive(:get).and_return(response)
      @zip = fda_facility_importer.fetch_zip
    end

    it 'fetches archive from FDA' do
      expect(HTTParty).to have_received(:get).with(fda_url)
    end

    it 'returns response body' do
      expect(@zip.read).to eq response_body
    end
  end

  describe 'processing zip archive' do
    describe '#extract_contents' do
      it 'unzips archive and returns contents of public.txt' do
        extracted_contents = fda_facility_importer.extract_contents(zip_buffer)
        expect(extracted_contents).to eq contents
      end
    end

    describe '#parse_contents' do
      it 'returns parsed rows' do
        parsed_rows = fda_facility_importer.parse_contents(contents)
        expect(parsed_rows).to eq rows
      end
    end
  end

  describe '#create_facility' do
    context 'with valid fields' do
      let(:fields) {
        ["Albert Einstein Med Ctr-Marion-Louise Saltzman Womens Ctr", "5501 Old York Road", nil, nil, "Philadelphia", "PA", "19141", "215254-2700", "215456-7578"]
      }
      let(:facility) { fda_facility_importer.create_facility(fields) }

      it 'should create a Facility' do
        expect(facility.id).to be_present
        expect(facility.name).to eq('Albert Einstein Med Ctr-Marion-Louise Saltzman Womens Ctr')
        expect(facility.address_1).to eq('5501 Old York Road')
        expect(facility.address_2).to be_nil
        expect(facility.address_3).to be_nil
        expect(facility.city).to eq('Philadelphia')
        expect(facility.state).to eq('PA')
        expect(facility.zip_code).to eq('19141')
        expect(facility.phone).to eq('215254-2700')
        expect(facility.fax).to eq('215456-7578')
      end
    end
  end

  describe '#import' do
    before do
      allow(HTTParty).to receive(:get).and_return(response)
    end

    it 'should import three Facilities' do
      FDAFacilityImporter.import
      expect(Facility.count).to eq(3)
    end
  end
end
