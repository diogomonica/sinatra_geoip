class AddDetailedColumns < ActiveRecord::Migration
  def up
  	change_table :geoip_entries do |t|
  		t.string :ip_address
  		t.string :user_agent
  		t.string :w3c_latitude
  		t.string :w3c_longitude
  		t.string :ip_latitude
  		t.string :ip_longitude
  		t.string :distance
  		t.timestamps
  	end
  end

  def down
	add_column :geoip_entries, :entry, :string
  end
end
