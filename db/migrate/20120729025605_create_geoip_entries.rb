class CreateGeoipEntries < ActiveRecord::Migration
  def up
  	create_table :geoip_entries do |t|
  		t.string :entry
  	end
  end

  def down
  	drop_table :geoip_entries, :entry, :string
  end
end
