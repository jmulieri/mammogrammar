require 'httparty'
require 'zip'

class FDAFacilityImporter
  FDA_ZIP_URL = 'http://www.accessdata.fda.gov/premarket/ftparea/public.zip'.freeze

  def self.import
    FDAFacilityImporter.new.import
  end

  def import
    parse_contents(extract_contents(fetch_zip)).each do |row|
      create_facility(row)
    end
  end

  def fetch_zip
    begin
      StringIO.new(HTTParty.get(FDA_ZIP_URL).body)
    rescue Exception => e
      Rails.logger.error(e.message)
      nil
    end
  end

  def extract_contents(body)
    begin
      Zip::InputStream.open(body) do |zip|
        entry = zip.get_next_entry
        entry.get_input_stream.read
      end
    rescue Exception => e
      Rails.logger.error(e.message)
      nil
    end
  end

  def parse_contents(contents)
    CSV.parse(contents, :col_sep => '|')
  end

  def create_facility(fields)
    Facility.create(
        name:      fields[0],
        address_1: fields[1],
        address_2: fields[2],
        address_3: fields[3],
        city:      fields[4],
        state:     fields[5],
        zip_code:  fields[6],
        phone:     fields[7],
        fax:       fields[8]
    )
  end
end