class AddCallsignColumnToFlights < ActiveRecord::Migration[5.2]
  def change
    add_column :flights, :callsign, :string
  end
end
