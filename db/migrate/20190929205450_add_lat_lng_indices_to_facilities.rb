class AddLatLngIndicesToFacilities < ActiveRecord::Migration[6.0]
  def change
    add_index :facilities, :lat, order: { lat: :asc }
    add_index :facilities, :lng, order: { lng: :asc }
  end
end
