require 'httparty'
require 'zip'

class FDAFacilityImporter
  FDA_ZIP_URL = 'http://www.accessdata.fda.gov/premarket/ftparea/public.zip'.freeze

  def self.import
    FDAFacilityImporter.new.import
  end

  def import
    ids_to_keep = []
    rows_to_import = []
    parse_contents(extract_contents(fetch_zip)).each do |row|
      facility = find_facility(row)
      if facility
        ids_to_keep << facility.id
      else
        rows_to_import << row
      end
    end
    # get ids of all facilities that were not an exact match
    ids_to_delete = Facility.select(:id).map(&:id) - ids_to_keep

    # delete all rows that are either no longer present or have changed
    # there is no definitive way of knowing if a facility has simply changed location,
    # just assume if we don't have it currently, that it is a new one, and also assume
    # any facilities that we have that are not in the feed should be removed
    Facility.where(id: ids_to_delete).delete_all
    rows_to_import.each do |row|
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

  def find_facility(fields)
    Facility.where(
        name:      fields[0],
        address_1: fields[1],
        address_2: fields[2],
        address_3: fields[3],
        city:      fields[4],
        state:     fields[5],
        zip_code:  fields[6],
        phone:     fields[7],
        fax:       fields[8]
    ).first
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
