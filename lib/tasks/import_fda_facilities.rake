require 'fda_facility_importer'

desc "Import mammography facilities from FDA zipfile"
task :import_fda_facilities => :environment do
  FDAFacilityImporter.import
end