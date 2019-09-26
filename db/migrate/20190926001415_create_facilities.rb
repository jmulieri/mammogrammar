class CreateFacilities < ActiveRecord::Migration[6.0]
  def change
    create_table :facilities do |t|
      t.string :name
      t.string :address_1
      t.string :address_2
      t.string :address_3
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :phone
      t.string :fax
      t.float :lat
      t.float :lng

      t.timestamps
    end
  end
end
